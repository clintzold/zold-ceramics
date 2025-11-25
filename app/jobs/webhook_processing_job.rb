class WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
      Product.create(title: "webhook working", description: "this works", price: 10.99, stock: 1)

    rescue StandardError => e
      Rails.logger.error "Error processing webhook event #{webhook_event.data.object.id}: #{e.message}"
  end
end
