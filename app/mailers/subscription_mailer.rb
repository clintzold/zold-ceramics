class SubscriptionMailer < ApplicationMailer
  default from: email_address_with_name("subscriptions@zoldceramics.com", "Jessie from Zold Ceramics")
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.welcome_email.subject
  #
  def welcome_email
    @subscription = params[:subscription]
    @email = @subscription.email
    @name = @subscription.first_name
    @token = Rails.application.message_verifier("subscription").generate({
      sub_id: @subscription.id,
      expires: 2.weeks.from_now
    })

    mail(to: @email, subject: "New Subscription" )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.goodbye_email.subject
  #
  def goodbye_email
    @subscription = params[:subscription]
    @email = @subscription.email
    @name = @subscription.first_name

    mail(to: @email, subject: "Subscription Cancellation" )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.new_batch_email.subject
  #
  def new_batch_email
    @subscription = params[:subscription]
    @email = @subscription.email
    @name = @subscription.first_name
    @token = Rails.application.message_verifier("subscription").generate({
      sub_id: @subscription.id,
      expires: 2.weeks.from_now
    })

    mail(to: @email, subject: "New Ceramics Available" )
  end
end
