# app/services/shipping_service/create_shipment.rb
module ShippingService
  class CreateShipment < ApplicationService
    def initialize(order_id:, rate_id:)
      @rate_id = rate_id
      @order_id = order_id
      @shipment_details = nil
      @shipment = nil
    end

    def call
      purchase_label

      create_shipment

      success(@shipment)
    rescue ShippingServiceError => e
      failure(e.message)
    end

    private

    def purchase_label
      result = ShippoService::PurchaseLabel.call(@rate_id)

      if result.success?
        @shipment_details = result.payload
      else
        raise ShippingServiceError("PurchaseLabel", result.errors.join(", "))
      end
    end


    def create_shipment
      result = OrderService::CreateShipment.call(
        order_id: @order_id,
        shipment_details: @shipment_details
      )

      if result.success?
        @shipment = result.payload
      else
        raise ShippingServiceError("CreateShipment", result.errors.join(", "))
      end
    end
  end
end
