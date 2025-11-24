class CheckoutController < ApplicationController
  before_action :get_cart_items
  def create
    @line_items = []
    if @cart.any?
      @cart.each do |product_id, details|
        product = Product.find(product_id)
        quantity = details["quantity"]
        @line_items << {
          price_data: {
            currency: "cad",
            product_data: {
              name: product.title
            },
            unit_amount: (product.price * 100).to_i
          },
          quantity: quantity
        }
      end
    end

    session = Stripe::Checkout::Session.create({
      payment_method_types: [ "card" ],
      line_items: @line_items,
      mode: "payment",
      success_url: "http://localhost:3000",
      cancel_url: "http://localhost:3000/about"
    })

    redirect_to session.url, allow_other_host: true
  end

  private

  def get_cart_items
    @cart = session[:cart]
  end
end
