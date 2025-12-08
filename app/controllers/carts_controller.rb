class CartsController < ApplicationController
  before_action :set_product, only: [ :add_item, :remove_item ]
  before_action :authenticate_user!
  # Load cart items for display
  def show
    @cart_items = current_user.cart_items
    @order_total = 0
    if @cart_items.any?
      @cart_items.each do |item|
        product = Product.find_by(id: item.product_id)
        @order_total += product.price * item.quantity unless !product
      end
    end
  end
  # Add product to cart
  def add_item
    amount_to_purchase = params[:num_of_items]
    cart = current_user.cart
    new_item = cart.cart_items.find_or_create_by(product_id: @product.id)
    new_item.quantity += amount_to_purchase.to_i
    new_item.save!
    redirect_to shop_path, notice: "#{@product.title} was added to cart."
  end
  # Remove product from cart
  def remove_item
    cart = current_user.cart
    cart.cart_items.delete_by(product_id: @product.id)
    redirect_to cart_path, notice: "#{@product.title} was removed from cart."
  end

  private

  def set_product
  @product = Product.find(params[:product_id])
  end
end
