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
        SubscriptionMailer.with(subscription: @subscription).welcome_email.deliver_later
        format.html { head :no_content }
      else
        puts @subscription.errors
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "subscribe_form_errors", partial: "shared/form_errors", locals: {errors: @subscription.errors}
          ), status: :unprocessable_content }
      end
    end
  end

  def destroy
    puts params[:token]
    cancel_token = cancel_params[:token]
    payload = Rails.application.message_verifier("subscription").verify(cancel_token)
    subscription = Subscription.find(payload["sub_id"])
    name = subscription.first_name
    email = subscription.email

    if subscription
      SubscriptionMailer.goodbye_email(name, email).deliver_later
      subscription.destroy
      render plain: "You have been unsubscribed."
    else
      render plain: "invalid unsubscribe link.", status: :unprocessable_content
    end
  end

  def index
    @subscriptions = Subscription.all
    render turbo_stream: turbo_stream.update(
      "new_batch", partial: "index", locals: { subscriptions: @subscriptions }
    )
  end

  def new_batch
    SendNewBatchEmailJob.perform_later
    head :no_content
  end

  def render_partial
    render turbo_stream: turbo_stream.update(
      "new_batch", partial: "new_batch"
    )
  end

  private

  def new_sub_params
    params.require(:subscription).permit(:first_name, :last_name, :email)
  end

  def cancel_params
    params.permit(:token)
  end
end
