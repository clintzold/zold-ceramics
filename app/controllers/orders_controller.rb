class OrdersController < ApplicationController
  before_action :current_cart
  before_action :authenticate_user!
  before_action :require_admin
  def create
    result = OrderService::Create.call(cart: @cart)
    if result.success?
      redirect_to checkout_path(order_id: result.payload.id)
    else
      redirect_to cart_path, alert: order.errors.join(", ")
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def index
    @statuses = Order.statuses.keys
    @orders = Order.all
    if params[:filtered_status].present?
      @orders = @orders.where(status: params[:filtered_status])
    end

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "filtered_results",
          partial: "results",
          locals: { orders: @orders }
        )
      }
    end
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to home_path, alert: "You are not authourized to view this page."
    end
  end
end
