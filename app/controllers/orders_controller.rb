class OrdersController < ApplicationController
  skip_before_action :require_authentication, only: [:create]

  def create
    result = OrderService::Create.call(cart: @cart)
    if result.success?
      redirect_to checkout_path(order_token: result.payload.token)
    else
      flash[:danger] = result.errors.join(", ")
      redirect_to shop_path
    end
  end

  def show
    @order = Order.find(order_params[:id])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "adminOptions",
          partial: "show",
          locals: { order: @order }
        )
      }
      format.html { redirect_to admin_path }
    end
  end

  def index
    @statuses = Order.statuses.keys
    
    case order_params[:order_type]
    when "2"
      @order_type = "Delivery"
      @orders = Order.where(local: false)
    when "3"
      @order_type = "Pickup"
      @orders = Order.where(local: true)
    else
      @order_type = "All"
      @orders = Order.all
    end

    if order_params[:filtered_status].present?
      @orders = @orders.where(status: params[:filtered_status])
    end

    respond_to do |format|
      format.html { redirect_to admin_path }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
            "adminOptions",
            partial: "index",
            locals: {orders: @orders, order_type: @order_type, statuses: @statuses}
          )
      }
    end
  end

  private

  def order_params
    params.permit(:id, :order_type, filtered_status: [])

  end
end
