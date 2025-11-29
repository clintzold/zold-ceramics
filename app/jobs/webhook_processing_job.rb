class WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)

      # Construct event from DB instead of HTTP request to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload).data.object

      # Adjust stock values of products purchased
      update_product_stock(event.id)

      # Create new customer in DB
      customer = Customer.create!(email: event.customer_details.email, name: event.customer_details.name, phone: event.customer_details.phone)

      # Create new order in DB through new customer
      customer.orders.create!(shipping_address: event.customer_details.address)

    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
    end
  end

  private

  def update_product_stock(checkout_session_id)
    begin
      line_items = Stripe::Checkout::Session.list_line_items(checkout_session_id)

      line_items.data.each do |item|
       product = Product.find_by(stripe_price_id: item.price.id)
       product.stock -= item.quantity.to_i
       product.save
      end

    rescue StandardError => e
      Rails.logger.error "Error during stock update operation: #{e.message}"
    end
  end
end
