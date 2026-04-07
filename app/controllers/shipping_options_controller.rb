class ShippingOptionsController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token
  before_action :retrieve_order_items

  def create
    result = ShippingService::GenerateOptions.call(
      shipping_details: shipping_params[:shipping_details],
      session_id: shipping_params[:checkout_session_id],
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

  def shipping_params
    params.permit(
      :checkout_session_id, 
      shipping_details: [
        :name,
        address: [
          :country, :line1,
          :line2, :city,
          :postal_code, :state
        ]
        
      ]
    )
  end

  def retrieve_order_items
    session = Stripe::Checkout::Session.retrieve(shipping_params[:checkout_session_id])
    order = Order.find_by(token: session.metadata.order_token)
    @order_items = order.order_items
  end
end
