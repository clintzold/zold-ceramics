class ShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]

  def create
    order_id = params[:order_id]
    result = ShippingService::CreateShipment.call(
      order_id: params[:order_id],
      rate_id: params[:rate_id]
    )

    if result.success?
      redirect_to shipment_path(result.payload.id), success: "Shipment created for Order##{params[:id]}"
    else
      render order_path(order_id), alert: result.errors.join(", ")
    end
  end

  def index
    @shipments = Shipment.all
    @statuses = Shipment.tracking_statuses.keys
    if params[:filtered_status].present?
      @shipments = @shipments.where(tracking_status: params[:filtered_status])
    end

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "filtered_results",
          partial: "results",
          locals: { shipments: @shipments }
        )
      }
    end
  end

  def show
    @shipment = Shipment.find(params[:id])
    @order = @shipment.order
  end
end
