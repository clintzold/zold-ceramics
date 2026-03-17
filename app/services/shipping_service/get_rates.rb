# app/services/shipping_services/get_rates.rb
module ShippingService
  class GetRates < ApplicationService
    def initialize(province:, order_value:)
      @province = province.downcase
      @order_value = order_value
      @base_cost = nil
      @value_rate = (order_value * 0.05).round(2)
      @rates = nil
    end

    def call
      # Call Shippo with shipment until rates are returned
      #
      # service object can be found at app/services/shippo_api_service.rb
      #
      # ***will need to modify this to avoid sending too many requests
      # during OAuth errors with carriers***
      #
      set_base_cost

      create_rates

      @rates
      
    end

    private

    def set_base_cost
      case @province
      when "alberta", "ab"
        @base_cost = 15
      when "british columbia", "bc"
        @base_cost = 20
      when "saskatchewan", "sk"
        @base_cost = 20
      when "manitoba", "mb"
        @base_cost = 25
      else
        @base_cost = 30
      end
    end

    def create_rates
      @rates = [
        {
          "service_level" => "UPS Standard",
          "amount" => @base_cost + @value_rate
        },
        {
          "service_level" => "UPS Express",
          "amount" => @base_cost + @value_rate + 10
        }
      ]
    end

  end
end
