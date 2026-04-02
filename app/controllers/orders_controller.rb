class OrdersController < ApplicationController
  skip_before_action :require_authentication, only: [:create]

  def create
    result = OrderService::Create.call(cart: @cart)
    if result.success?
      redirect_to checkout_path(order_id: result.payload.id)
    else
      flash[:danger] = result.errors.join(", ")
      redirect_to shop_path
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

end
