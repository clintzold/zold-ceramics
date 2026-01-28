class CartsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_product, only: [ :add_item, :remove_item ]

  # Load cart items for display
  def show
    @order_total = 0
    if @cart.cart_items
      @cart.cart_items.each do |item|
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

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
        turbo_stream.update("cart_counter", partial: "carts/cart_counter"),
        turbo_stream.update(
          "cart_button_frame",
          partial: "layouts/cart_button",
          locals: { animation_type: "bounce-cart" }),
        turbo_stream.update(
          "cart_summary_frame",
          partial: "carts/cart_summary",
          locals: { show: "hidden", cart: @cart }
        )
        ]
      }
    end
  end
  # Remove product from cart
  def remove_item
    @cart.cart_items.delete_by(product_id: @product.id)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update("cart_counter", partial: "carts/cart_counter"),
          turbo_stream.update(
            "cart_summary_frame",
            partial: "carts/cart_summary",
            locals: { show: "show", cart: @cart }),
        turbo_stream.update(
          "cart_button_frame",
          partial: "layouts/cart_button",
          locals: { animation_type: nil })
        ]
      }
    end
  end

  private

  def set_product
  @product = Product.find(params[:product_id])
  end
end
