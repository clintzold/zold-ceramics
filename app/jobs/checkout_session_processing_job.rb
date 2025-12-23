class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)
      # Construct event from DB instead of HTTP request
      # to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload)
      event_details = event.data.object
      order_id = event_details.metadata.order_id

      case event.type
      when "checkout.session.completed"
        OrderService::Paid.call(order_id: order_id, order_details: event_details)
        webhook_event.toggle!(:processed)
      when "checkout.session.expired"
        OrderService::Cancel.call(order_id).call
        webhook_event.toggle!(:processed)
      end
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event: #{e.message}"
    end
  end
end
