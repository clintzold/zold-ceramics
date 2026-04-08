class SubscriptionsController < ApplicationController
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
    @subscription = Subscription.new(sub_params)

    respond_to do |format|
      if @subscription.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "sign_up", partial: "success", locals: {subscription: @subscription}
          )}
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "sign_up", partial: "new", locals: {subscription: @subscription}
          )}
      end
    end
  end

  def destroy
    cancel_token = params[:cancel_token]
    payload = Rails.application.message_verifier("subscription").verify(cancel_token)
    subscription = Subscription.find(payload[:sub_id])

    if subscription
      SubscriptionMailer.with(subscription).goodbye_email.deliver_later
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
end
