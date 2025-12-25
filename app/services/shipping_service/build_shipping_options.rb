# app/services/shipping_services/build_shipment_options
#
# This class necessarily builds an array of shipping options in
# the format Stripe expects to receive to update it's embedded UI
# dynamically.
#
# This allows users to select shipping rates provided in real time
# by making a call to the Shippo shipment API.

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
            display_name: rate["servicelevel"]["display_name"],
            type: "fixed_amount",
            fixed_amount: {
              currency: rate["currency_local"],
              amount: (rate["amount_local"].to_i * 100).to_s
            },
            #
            # This id is KEY to retrieving the unique rate generated
            # for each order by Shippo.
            #
            # It is impossible to purchase the label via API call
            # later without it!
            metadata: { object_id: rate["object_id"] }
          }
        }
      end
    end
  end
end
