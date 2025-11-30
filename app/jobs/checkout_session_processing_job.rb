class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)

      # Construct event from DB instead of HTTP request to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload).data.object

      # Retrieve line items from session
      line_items = Stripe::Checkout::Session.list_line_items(event.id)

      # Adjust stock values of products purchased and place order
      update_product_stock(line_items)

      # Create a new order in DB through customer/user
      create_order(line_items, event.customer_details.address, event.customer_details.email)

    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
    end
  end

  private

  def update_product_stock(line_items)
    begin
      line_items.data.each do |item|
       product = Product.find_by(stripe_price_id: item.price.id)
       product.stock -= item.quantity.to_i
       product.save
      end

    rescue StandardError => e
      Rails.logger.error "Error during stock update operation: #{e.message}"
    end
  end

  def create_order(line_items, shipping_address, customer_email)
    begin
      products_details = []
      line_items.data.each do |item|
        products_details << {
          "stripe_product_id" => item.price.product,
          "product_name" => item.description,
          "price_per_unit" => item.price.unit_amount,
          "quantity" => item.quantity,
          "total_amount" => item.amount_subtotal
        }
      end
      customer = User.find_by(email: customer_email)
      customer.orders.create!(shipping_address: shipping_address, product: products_details)
    rescue StandardError => e
      Rails.logger.error "Error during order creation: #{e.message}"
    end
  end
end
