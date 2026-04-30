class Admin::OrdersController < Admin::BaseController
  before_action :filter_orders, only: [:filter]

  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.turbo_stream {
        @pickup = Pickup.find(params[:pickup_id])

        render turbo_stream: turbo_stream.update(
          "pickups", partial: "order_preview", locals: { order: @order, pickup: @pickup }
        )
      }
      format.html
    end
  end

  def index
    @orders = Order.where.not(status: "pending")
    @statuses = ["paid", "delivered"]
  end

  def delivered
    order = Order.find(params[:id])
    order.update(status: "delivered")
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("order_status", partial: "status", locals: { order: order })
      }
      format.html {
        redirect_to admin_order_path(order)
      }
    end
  end

  def paid
    order = Order.find(params[:id])
    order.update(status: "paid")

    redirect_to admin_order_path(order)
  end

  def filter
    respond_to do |format|
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

  def order_params
    params.permit(:id, :order_type, filtered_status: [])
  end

  def filter_orders
    @statuses = ["paid", "delivered"]
    
    case order_params[:order_type]
    when "2"
      @order_type = "Delivery"
      @orders = Order.where.not(status: "pending").where(local: false)
    when "3"
      @order_type = "Pickup"
      @orders = Order.where.not(status: "pending").where(local: true)
    else
      @order_type = "All"
      @orders = Order.where.not(status: "pending")
    end

    if order_params[:filtered_status].present?
      @orders = @orders.where(status: params[:filtered_status])
    end
  end
end
