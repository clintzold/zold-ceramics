class SendNewBatchEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    subscriptions = Subscription.all
    
    subscriptions.each do |sub|
      SubscriptionMailer.with(subscription: sub).new_batch_email.deliver_later
    end
  end
end
