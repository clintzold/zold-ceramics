# app/services/shipping_services/get_rates.rb
module ShippingService
  class GetRates < ApplicationService
    def initialize(shipment)
      @shipment = shipment
    end

    def call
      # Call Shippo with shipment until rates are returned
      #
      # service object can be found at app/services/shippo_api_service.rb
      #
      # ***will need to modify this to avoid sending too many requests
      # during OAuth errors with carriers***
      #
      retries = 0
      5.times do
        result = ShippoService::CreateShipment.call(shipment_details: @shipment)
        if result.payload.any?
         return success(result.payload)
        end
        retries += 1
      end

      failure("Error retrieving rates from Shippo: #{result.errors.join(', ')}")
    end
  end
end
