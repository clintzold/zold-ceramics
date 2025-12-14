# app/services/shippo_api_service.rb
class ShippoCreateShipmentService
    BASE_URL = "https://api.goshippo.com/"

  def initialize(shipping_details:)
    @shipping_details = shipping_details
    @api_token = Rails.application.credentials.shippo[:test_key]
    @body = nil
  end

  # Method to access retrieved rates from service object
  def rates
    @body["rates"]
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
      address_from: @shipping_details["address_from"],
      address_to: @shipping_details["address_to"],
      parcels: @shipping_details["parcels"],
      async: false,
      carrier_accounts: [ "5c075acf57cf49b492378f095fe7fd84" ]
    }.to_json

    response = http.request(request)

    handle_response(response)
    @body = JSON.parse(response.body)
  end

  private

  def handle_response(response)
    puts response
    case response.code.to_i
    when 200..299
      # Do nothing when response is OK
    when 401
      { error: "Authentication failed: Check API Token", details: JSON.parse(response.body) }
    else
      { error: "API reqest failed with stats #{response.code}", details: JSON.parse(response.body) }
    end
  end
end
