# app/services/shipping_services/update_checkout.rb
module ShippingService
  class UpdateCheckout < ApplicationService
    def initialize(session_id:, shipping_details:, shipping_options:)
      @session_id = session_id
      @name = shipping_details["name"]
      @address = shipping_details["address"]
      @shipping_options = shipping_options
    end

    def call
      Stripe::Checkout::Session.update(@session_id, {
        collected_information: {
          shipping_details: {
            name: @name,
            address: {
              line1: @address["line1"],
              line2: @address["line2"],
              city: @address["city"],
              country: @address["country"],
              state: @address["state"],
              postal_code: @address["postal_code"]
            }
          }
        },
        shipping_options: @shipping_options
      })
      success()
    rescue Stripe::StripeError => e
      failure("Error updating Stripe Checkout: #{e.message}")
    end
  end
end
