class CartsController < ApplicationController
  def show
    @cart_items = current_cart
  end

  def add_item
    product = Product.find(params[:product_id])
    cart = current_cart
    cart[product.id.to_s] ||= { quantity: 0 }
    cart[product.id.to_s][:quantity] += 1
    session[:cart] = cart

    redirect to cart_path
  end

  def remove_item
    cart = current_cart
    cart.delete(params[:product_id])
    session[:cart] = cart

    redirect_to cart_path
  end

  private

  def current_cart
    session[:cart] ||={}
  end
end
