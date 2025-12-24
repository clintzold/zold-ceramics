class CheckoutController < ApplicationController
  before_action :create_line_items, only: [ :new ]
  before_action :current_cart
  include Rails.application.routes.url_helpers

  # Generate a new Stripe checkout session
  def new
    puts params[:order_id]
    result = StripeService::Checkout.call(
      order_id: params[:order_id],
      line_items: @line_items,
      success_url: checkout_success_url
    )
    # Session must be instance variable to pass client's secret key to view
    if result.success?
      @session = result.payload
    else
      redirect_to cart_path, alert: result.errors.join(", ")
    end
  end

  # Order payment succeeds
  def success
    session_id = params[:session_id]
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
