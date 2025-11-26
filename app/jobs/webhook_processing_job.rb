class WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    payload = webhook_event.payload
    session_id = JSON.parse(payload)["id"]
    session = Stripe::Event.retrieve(session_id).data.object
    customer = Customer.create!(email: session.customer_details.email, name: session.customer_details.name, phone: session.customer_details.phone)
    puts customer.name
    customer.orders.create!(shipping_address: session.customer_details.address)
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
  end
end
