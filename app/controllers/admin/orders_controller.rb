class Admin::OrdersController < Admin::BaseController
  before_action :filter_orders, only: [:filter]

  def show
    @order = Order.find(order_params[:id])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "modal", partial: "order_modal", locals: { order: @order }
        )
      }
      format.html
    end
  end

  def index
    @orders = Order.all
    @statuses = Order.statuses.keys
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
  end
end
