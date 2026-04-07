class CheckoutController < ApplicationController
  allow_unauthenticated_access
  before_action :create_line_items, only: [ :new ]
  include Rails.application.routes.url_helpers

  # Generate a new Stripe checkout session
  def new
    # Make sure cart is emptied and cart widget disappears
    current_cart.cart_items.destroy_all
    
    # Call stripe for embedded checkout form with order details
    result = StripeService::Checkout.call(
      order_token: checkout_params[:order_token],
      line_items: @line_items,
      success_url: checkout_success_url
    )
    # Session must be instance variable to pass client's secret key to view
    if result.success?
      @session = result.payload
    else
      redirect_to shop_path, warning: result.errors.join(", ")
    end
  end

  # Order payment succeeds
  def success
    session_id = checkout_params[:session_id]
    if session_id.present?
      begin
        @checkout_details = Stripe::Checkout::Session.retrieve(session_id)
      rescue Stripe::InvalidRequestError => e
        flash[:error] = "Error retrieving checkout session: #{e.message}"
      end
    end
  end
  # Order payment fails or times out
  def cancel
  end

  private

  def checkout_params
    params.permit(:session_id, :order_token)
  end

  # Prepare cart items for Stripe processing
  def create_line_items
    @line_items = []
    cart_items = current_cart.cart_items
    if cart_items.any?
      cart_items.each do |item|
        @line_items << {
          price: item.product.stripe_price_id,
          quantity: item.quantity
        }
      end
    end
    @line_items
  end
end
