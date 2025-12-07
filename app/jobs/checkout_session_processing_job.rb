class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)
      # Construct event from DB instead of HTTP request to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload).data.object
      # Create a new order in DB through customer/user
      update_order_paid(order_id: event.metadata.order_id, shipping_address: event.customer_details.address, customer_email: event.customer_details.email)
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
    end
  end

  private

  # Create a new order in the DB
  def update_order_paid(order_id:, shipping_address:, customer_email:)
    begin
      puts order_id
      order = Order.find(order_id)
      order.update!(shipping_address: shipping_address, status: 1)
    rescue StandardError => e
      Rails.logger.error "Error during order creation: #{e.message}"
    end
  end
end
