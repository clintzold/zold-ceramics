class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)
      # Construct event from DB instead of HTTP request to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload)
      event_details = event.data.object

      # Update order status based on event type, mark webhook as processed
      case event.type
      when "checkout.session.completed"
        update_order_paid(event_details)
        webhook_event.toggle!(:processed)
      when "checkout.session.expired"
        update_order_canceled(order_id: event_details.metadata.order_id)
        webhook_event.toggle!(:processed)
      end
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event: #{e.message}"
    end
  end

  private

  # Update order status to paid
  def update_order_paid(order_details:)
    begin
      order = Order.find(order_id)
      order.update!(
        shipping_address: order_details.customer_details.address,
        email: order_details.customer_details.email,
        name: order_details.customer_details.name,
        status: 1
      )
    rescue StandardError => e
      Rails.logger.error "Error during order creation: #{e.message}"
    end
  end
  # Update order status to canceled
  def update_order_canceled(order_id:)
    begin
      order = Order.find(order_id)
      order.update!(status: 2)
    rescue StandardError => e
      Rails.logger.error "Error during order creation: #{e.message}"
    end
  end
end
