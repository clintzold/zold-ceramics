class CheckoutController < ApplicationController
  before_action :get_cart_items
  include Rails.application.routes.url_helpers


  def create
    @line_items = []
    if @cart.any?
      @cart.each do |product_id, details|
        product = Product.find(product_id)
        quantity = details["quantity"]
        image_url = product.main_image.attached? ? rails_blob_url(product.main_image, only_path: false, host: request.base_url) : nil
        @line_items << {
          price: product.stripe_price_id,
          quantity: quantity
        }
      end
    end

    session = Stripe::Checkout::Session.create({
      payment_method_types: [ "card" ],
      line_items: @line_items,
      mode: "payment",
      automatic_tax: { enabled: true },
      shipping_address_collection: { allowed_countries: [ "CA" ] },
      success_url: checkout_success_url,
      cancel_url: "http://localhost:3000/about"
    })

    redirect_to session.url, allow_other_host: true
  end

  def success
    session_id = params[:session_id]

    if session_id.present?
      begin
        checkout_session = Stripe::Checkout::Session.retrieve(session_id)

        @order_details = {
          customer_email: checkout_session.customer_email,
          amount_total: checkout_session.amount_total,
          currency: checkout_session.currency,
          shipping_address: checkout_session.shipping_details
        }
        flash[:success] = "Payment successful!"
      rescue Stripe::InvalidRequestError => e
        flash[:error] = "Error retrieving checkout session: #{e.message}"
      end

    end
  end

  def cancel
  end

  private

  def get_cart_items
    @cart = session[:cart]
  end
end
