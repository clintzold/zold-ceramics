# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/welcome_email
  def welcome_email
    SubscriptionMailer.welcome_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/goodbye_email
  def goodbye_email
    SubscriptionMailer.goodbye_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/new_batch_email
  def new_batch_email
    SubscriptionMailer.new_batch_email
  end

end
