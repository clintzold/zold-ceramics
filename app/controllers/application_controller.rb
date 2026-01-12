class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :current_cart

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def current_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
  helper_method :current_cart # Makes the method available in views

  def cart_count
    cart_count = 0
    if @cart.cart_items.any?
      @cart.cart_items.each do |item|
        cart_count += item.quantity
      end
    end
    cart_count
  end
  helper_method :cart_count
end
