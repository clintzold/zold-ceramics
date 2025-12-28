# app/services/shippo_service/create_shipment.rb
module ShippoService
  class CreateShipment < ApplicationService
      BASE_URL = "https://api.goshippo.com/"

    def initialize(shipment_details:)
      @shipment_details = shipment_details
      @api_token = Rails.application.credentials.shippo[:test_key]
      @body = nil
    end

    def call
      uri = URI.parse("#{BASE_URL}shipments/")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, {
        "Content-Type" => "application/json",
        "Authorization" => "ShippoToken #{@api_token}",
        "Accept" => "application/json"
      })

      request.body = {
        address_from: @shipment_details["address_from"],
        address_to: @shipment_details["address_to"],
        parcels: @shipment_details["parcels"],
        async: false,
        carrier_accounts: [ "5c075acf57cf49b492378f095fe7fd84" ]  # Currently set to UPS account key
      }.to_json

      response = http.request(request)

      @body = JSON.parse(response.body)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.code.to_i
      when 200..299
        ShippingRate.create!(body: @body)
        success(@body["rates"])
      when 401
        failure("Authentication failed: Check API Token")
      else
        failure("API request failed with stats #{response.code}")
      end
    end
  end
end
