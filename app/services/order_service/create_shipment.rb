# app/services/order_service/create_shipment.rb
module OrderService
  class CreateShipment < ApplicationService
    def initialize(order_id:, shipment_details:)
      @order = Order.find(order_id)
      @shipment_details = shipment_details
    end

    def call
      @order.build_shipment(
        parcel: @shipment_details["parcel"],
        tracking_number: @shipment_details["tracking_number"],
        tracking_status: @shipment_details["tracking_status"].downcase,
        tracking_url_provider: @shipment_details["tracking_url_provider"],
        label_url: @shipment_details["label_url"]
      )
      if @order.save
        success(@order.shipment)
      else
        failure(@order.errors.full_messages)
      end
    end
  end
end
