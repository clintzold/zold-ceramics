class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)
      # Construct event from DB instead of HTTP request
      # to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload)
      checkout_details = event.data.object

      case event.type
      when "checkout.session.completed"
        OrderService::Paid.call(checkout_details)
        webhook_event.toggle!(:processed)
      when "checkout.session.expired"
        OrderService::Cancel.call(checkout_details.metadata.order_id)
        webhook_event.toggle!(:processed)
      end
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event: #{e.message}"
    end
  end
end
