# app/services/shippo_service/create_order.rb
module ShippoService
  class CreateOrder < ApplicationService
      BASE_URL = "https://api.goshippo.com/"

    def initialize(order_id)
      @order = Order.find(order_id)
      @api_token = Rails.application.credentials.shippo[:secret_key]
      @to_address = nil
      @line_items = []
      @request_body = nil
      @response = nil
    end

    def call
      build_address

      build_line_items

      finalize_request_body

      call_shippo_with_order

      handle_response
    end

    private

    def build_address
      details = @order.shipping_address
      @to_address = {
        city: details["city"],
        state: details["state"],
        street1: details["line1"],
        street2: details["line2"],
        zip: details["postal_code"],
        country: details["country"],
        email: @order.email,
        name: @order.name
      }
    end

    def build_line_items
      @order.order_items.each do |item|
        @line_items << {
          quantity: item.quantity,
          title: item.product.title,
          total_price: (item.quantity * item.price.to_i),
          currency: "CAD",
          weight: (item.weight / 100).to_s,
          weight_unit: "kg"
        }
      end
    end

    def finalize_request_body
      @request_body = {
        to_address: @to_address,
        line_items: @line_items,

        placed_at: Time.now.utc.iso8601,  # eg. "2023-10-27T10:00:00Z" Must be in exact format Shippo Expects -> "2016-09-23T01:28:12Z"
        order_number: @order.id,
        order_status: "PAID",
        shipping_cost: @order.shipping_total,
        shipping_cost_currency: "CAD",
        shipping_method: @order.shipping_rate,
        subtotal_price: @order.sub_total,
        total_price: @order.total,
        currency: "CAD"
      }.to_json
    end

    def call_shippo_with_order
      uri = URI.parse("#{BASE_URL}orders/")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, {
        "Content-Type" => "application/json",
        "Authorization" => "ShippoToken #{@api_token}",
        "Accept" => "application/json"
      })

      request.body = @request_body

      @response = http.request(request)
    end

    def handle_response
      case @response.code.to_i
      when 200..299
        success(JSON.parse(@response.body))
      when 401
        failure("Authentication failed: Check API Token")
      else
        failure("API request failed with stats #{@response.code}")
      end
    end
  end
end
