# app/services/shippo_service/purchase_label.rb
module ShippoService
  class PurchaseLabel < ApplicationService
      BASE_URL = "https://api.goshippo.com/"

    def initialize(rate_id)
      @shipping_rate_id = rate_id
      @api_token = Rails.application.credentials.shippo[:secret_key]
      @body = nil
    end

    def call
      uri = URI.parse("#{BASE_URL}transactions/")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, {
        "Content-Type" => "application/json",
        "Authorization" => "ShippoToken #{@api_token}",
        "Accept" => "application/json"
      })

      request.body = {
        rate: @shipping_rate_id,
        async: false,
        label_file_type: "PDF"
      }.to_json

      response = http.request(request)

      @body = JSON.parse(response.body)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.code.to_i
      when 200..299
        success(@body)
      when 401
        failure("Authentication failed: Check API Token")
      else
        failure("API request failed with stats #{response.code}")
      end
    end
  end
end
