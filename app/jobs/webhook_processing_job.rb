class WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    payload = webhook_event.payload
    event_id = JSON.parse(payload)["id"]
    event = Stripe::Event.retrieve(event_id)
    Customer.create!(email: event.data.object.customer_details.email)

    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
  end
end
