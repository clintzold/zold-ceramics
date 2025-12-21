class OrderController < ApplicationController
  before_action :current_cart
  def create
    puts current_cart.cart_items
    result = OrderService::Create.call(cart: @cart)
    if result.success?
      redirect_to checkout_path, order_id: result.payload.id
    else
      redirect_to cart_path, alert: order.errors.join(", ")
    end
  end
end
