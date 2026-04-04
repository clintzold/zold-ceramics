class SubscriptionsController < ApplicationController
  def new
    @subscription = Subcription.new
  end

  def create
    @subscription = Subscription.new(subcription_params)

    respond_to do |format|
      if @subscription.save
        format.turbo_stream
      else
        format.html {render :new, status: :unprocessable_content}
      end
    end

  end
end
