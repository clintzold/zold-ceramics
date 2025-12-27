# app/services/shipping_services/get_rates.rb
module ShippingService
  class GetRates < ApplicationService
    def initialize(shipment)
      @shipment = shipment
    end

    def call
      request = ShippoCreateShipmentService.new(shipment_details: @shipment)

      # Call Shippo with shipment until rates are returned
      #
      # service object can be found at app/services/shippo_api_service.rb
      #
      # ***will need to modify this to avoid sending too many requests
      # during OAuth errors with carriers***
      #
      retries = 0
      begin
        request.call
        if request.rates.any?
          success(request.rates)
        else
          raise StandardError.new(
            "Error during shipping rates request to Shippo: No rates retrieved!"
          )
        end
      rescue StandardError => e
        if retries > 5
          failure(
            "Error retrieving rates from Shippo. #{retries} attempts made: #{e.message}"
          )
        end
        retries += 1
        retry
      end
    end
  end
end
