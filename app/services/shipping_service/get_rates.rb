# app/services/shipping_services/get_rates.rb
module ShippingService
  class GetRates < ApplicationService
    def initialize(province:, order_value:)
      @province = province.downcase
      @order_value = order_value
      @base_cost = nil
      @value_rate = (order_value * 0.05).round(2)
      @packaging_cost = 5
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
      when "alberta", "ab", "british columbia", "bc", "sakatchewan", "sk"
        @base_cost = 15
      when "manitoba", "mb", "ontario", "on", "quebec", "qc"
        @base_cost = 18
      when "yukon", "yt", "northwest territories", "nt"
        @base_cost = 30
      else
        @base_cost = 45
      end
    end

    def create_rates
      @rates = [
        {
          "service_level" => "Standard",
          "amount" => @base_cost + @value_rate + @packaging_cost,
          "delivery_estimate" => {
            "maximum" => {
              unit: "day",
              value: 7
            },
            "minimum" => {
              unit: "day",
              value: 5
            }
          }
        },
        {
          "service_level" => "Express",
          "amount" => @base_cost + @value_rate + @packaging_cost + 15, 
          "delivery_estimate" => {
            "maximum" => {
              unit: "day",
              value: 5
            },
            "minimum" => {
              unit: "day",
              value: 3
            }
          }
        },
        {
          "service_level" => "Local Pickup(Central Alberta)",
          "amount" => @packaging_cost,
          "delivery_estimate" => {
            "maximum" => {
              unit: "day",
              value: 7
            },
            "minimum" => {
              unit: "day",
              value: 1
            }
          }
        }
      ]
    end

  end
end
