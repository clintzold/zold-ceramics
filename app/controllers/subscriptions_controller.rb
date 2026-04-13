class SubscriptionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @subscription = Subscription.new
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update(
          "sign_up", partial: "new", locals: {subscription: @subscription}
        )}
    end
  end

  def create
    @subscription = Subscription.new(new_sub_params)

    respond_to do |format|
      if @subscription.save
        format.html { head :no_content }
        SubscriptionMailer.with(subscription: @subscription).welcome_email.deliver_later
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "sign_up", partial: "new", locals: {subscription: @subscription}
          )}
      end
    end
  end

  def destroy
    cancel_token = cancel_params[:cancel_token]
    payload = Rails.application.message_verifier("subscription").verify(cancel_token)
    subscription = Subscription.find(payload[:sub_id])

    if subscription
      SubscriptionMailer.with(subscription: subscription).goodbye_email.deliver_later
      subscription.destroy
      render plain: "You have been unsubscribed."
    else
      render plain: "invalid unsubscribe link.", status: :unprocessable_content
    end
  end

  def index
    @subscriptions = Subscription.all
  end

  private

  def new_sub_params
    params.require(:subscription).permit(:first_name, :last_name, :email)
  end

  def cancel_params
    params.permit(:cancel_token)
  end
end
