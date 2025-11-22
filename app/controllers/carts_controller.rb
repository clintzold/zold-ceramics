class CartsController < ApplicationController
  def show
    @cart_items = current_cart

    @order_total = 0

    if @cart_items.any?
      @cart_items.each do |product_id, details|
        product = Product.find(product_id)
        @order_total += product.price * details["quantity"]
      end
    end
  end

  def add_item
    product = Product.find(params[:product_id])
    amount_to_purchase = params[:num_of_items]
    cart = current_cart
    cart[product.id.to_s] ||= { "quantity" => 0 }
    cart[product.id.to_s]["quantity"] += amount_to_purchase.to_i
    session[:cart] = cart

    redirect_to shop_path, notice: "#{product.title} was added to cart."
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
