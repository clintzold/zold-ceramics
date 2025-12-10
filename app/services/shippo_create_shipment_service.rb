# app/services/shippo_api_service.rb
class ShippoCreateShipmentService
    BASE_URL = "https://api.goshippo.com/"

  def initialize(address_from:, address_to:, parcels:)
    @address_from = address_from
    @address_to = address_to
    @parcels = parcels
    @api_token = Rails.application.credentials.shippo[:test_key]
  end

  def call
    puts @api_token
    uri = URI.parse("#{BASE_URL}shipments/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "ShippoToken #{@api_token}",
      "Accept" => "application/json"
    })

    request.body = {
      address_from: @address_from,
      address_to: @address_to,
      parcels: @parcels,
      async: false
    }.to_json

    response = http.request(request)

    handle_response(response)
  end

  private

  def handle_response(response)
    puts response
    case response.code.to_i
    when 200..299
      ShippingRate.create!(body: JSON.parse(response.body))
    when 401
      { error: "Authentication failed: Check API Token", details: JSON.parse(response.body) }
    else
      { error: "API reqest failed with stats #{response.code}", details: JSON.parse(response.body) }
    end
  end
end
