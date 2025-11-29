class WebhookEvent < ApplicationRecord
  after_create_commit :process_webhook_event

  private

  def process_webhook_event
    CheckoutSessionProcessingJob.perform_later(self)
  end
end
