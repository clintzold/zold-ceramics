class OrdersController < ApplicationController
  skip_before_action :require_authentication

  def create
    result = OrderService::Create.call(cart: @cart)
    if result.success?
      redirect_to checkout_path(order_token: result.payload.token)
    else
      flash[:danger] = result.errors.join(", ")
      redirect_to shop_path
    end
  end
end
