# app/services/shipping_services/build_shipment_options
#
# This class necessarily builds an array of shipping options in
# the format Stripe expects to receive to update it's embedded UI
# dynamically.
#
# This allows users to select shipping rates provided in real time
# by making a call to the Shippo shipment API.
#
module ShippingService
  class BuildShippingOptions < ApplicationService
    attr_reader :shipping_options

    def initialize(rates)
      @rates = rates
      @shipping_options = []
    end

    def call
      @rates.each do | rate |
        @shipping_options << {
          shipping_rate_data: {
            display_name: rate["service_level"],
            type: "fixed_amount",
            fixed_amount: {
              currency: "CAD",
              amount: (rate["amount"] * 100).to_s
            }
        }
      end
      success(@shipping_options)
    rescue StandardError => e
      Rails.logger.error "There was an error converting shipping rates for Stripe: #{e.message}"
      failure(e.message)
    end
  end
end
