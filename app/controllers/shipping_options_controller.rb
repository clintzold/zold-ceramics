class ShippingOptionsController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token
  before_action :retrieve_order_items

  def create
    result = ShippingService::GenerateOptions.call(
      shipping_details: params[:shipping_details],
      session_id: params[:checkout_session_id],
      order_items: @order_items
    )

    if result.success?
      @response = { type: "object", value: { succeeded: true } }
    else
      Rails.logger.error result.errors.join(", ")
      @response = { type: "error", message: "We could not find shipping options. Please review your shipping address and try again." }
    end

    respond_to do |format|
      format.json { render json: @response }
    end
  end

  private

  def retrieve_order_items
    session = Stripe::Checkout::Session.retrieve(params[:checkout_session_id])
    order = Order.find(session.metadata.order_id)
    @order_items = order.order_items
  end
end
