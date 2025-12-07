class CheckoutController < ApplicationController
  before_action :create_line_items, only: [ :new ]
  include Rails.application.routes.url_helpers

  # Generate a new Stripe checkout session
  def new
    order = OrderService.new(user: current_user)
    order.call
    if order.success?
      # Begin Stripe checkout
      service = StripeCheckoutService.new(line_items: @line_items, success_url: checkout_success_url, cancel_url: checkout_success_url)
      # Session must be instance variable to pass client's secret key to view
      @session = service.call
      if !@session
        redirect_to cart_path, alert: "There was an error processing this order."
      end
    else
      # Return to cart and display error details if order creation fails
      redirect_to cart_path, alert: order.errors
    end
  end

  # Order payment succeeds
  def success
    session_id = params[:session_id]
    if session_id.present?
      begin
        checkout_session = Stripe::Checkout::Session.retrieve(session_id)
        @order_details = {
          customer_email: checkout_session.customer_email,
          amount_total: checkout_session.amount_total,
          currency: checkout_session.currency
        }
        flash[:success] = "Payment successful!"
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
    cart_items = current_user.cart_items
    if cart_items.any?
      cart_items.each do |item|
        product = Product.find(item.product_id)
        @line_items << {
          price: product.stripe_price_id,
          quantity: item.quantity
        }
      end
    end
    @line_items
  end
end
