class SubscriptionMailer < ApplicationMailer
  default_from: 'subscriptions@zoldceramics.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.welcome_email.subject
  #
  def welcome_email
    @subscriber = params[:subscriber]
    @email = @subscriber.email
    @name = @subscriber.name
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.goodbye_email.subject
  #
  def goodbye_email
    @subscriber = params[:subscriber]
    @email = @subscriber.email
    @name = @subscriber.name
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.new_batch_email.subject
  #
  def new_batch_email
    @subscriber = params[:subscriber]
    @email = @subscriber.email
    @name = @subscriber.name
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
