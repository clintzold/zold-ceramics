class ShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    result = ShippingService::CreateShipment.call(
      order_id: params[:id],
      rate_id: params[:rate_id]
    )

    if result.success?
      redirect_to shipment_path(result.payload.id), success: "Shipment created for Order##{params[:id]}"
    else
      render orders_path, danger: result.errors.join(", ")
    end
  end

  def index
    @shipments = Shipment.all
  end

  def show
    @shipment = Shipment.find(params[:id])
  end
end
