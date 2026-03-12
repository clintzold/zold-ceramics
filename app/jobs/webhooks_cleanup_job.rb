class WebhooksCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Webhook.where("created_at < ?", 30.days.ago).delete_all
  end
end
