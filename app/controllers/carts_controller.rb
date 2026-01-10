class CartsController < ApplicationController
  before_action :set_product, only: [ :add_item, :remove_item ]
  before_action :current_cart
  # Load cart items for display
  def show
    @cart_items = @cart.cart_items
    @order_total = 0
    if @cart_items.any?
      @cart_items.each do |item|
        @order_total += item.product.price * item.quantity
      end
    end
  end
  # Add product to cart
  def add_item
    amount_to_purchase = params[:num_of_items]
    new_item = @cart.cart_items.find_or_create_by(product_id: @product.id)
    new_item.quantity += amount_to_purchase.to_i
    new_item.save!
    flash[:success] = "#{@product.title} was added to cart."
    redirect_to cart_path
  end
  # Remove product from cart
  def remove_item
    @cart.cart_items.delete_by(product_id: @product.id)
    flash[:notice] = "#{@product.title} was removed from cart."
    redirect_to cart_path
  end

  private

  def set_product
  @product = Product.find(params[:product_id])
  end
end
