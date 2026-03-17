# app/services/shipping_services/generate_options.rb
module ShippingService
  class GenerateOptions < ApplicationService
    def initialize(shipping_details:, session_id:, order_items:)
      @session_id = session_id
      @shipping_details = shipping_details
      @order_items = order_items
      @rates = nil
      @shipping_options = nil
    end

    def call
      get_rates

      build_shipping_options

      update_stripe_checkout

      success()
    rescue ShippingServiceError => e
      failure(e.message)
    end

    private

    def get_rates
      order_value = 0
      @order_items.each { |item| order_value += item.price}

      @rates = ShippingService::GetRates.call(
        province: @shipping_details["address"]["state"],
        order_value: order_value
      )
    end

    def build_shipping_options
      result = ShippingService::BuildShippingOptions.call(
        @rates
      )

      if result.success?
        @shipping_options = result.payload
      else
        raise ShippingServiceError.new("BuildShippingOptions", result.errors)
      end
    end

    def update_stripe_checkout
      result = StripeService::UpdateCheckout.call(
        session_id: @session_id,
        shipping_details: @shipping_details,
        shipping_options: @shipping_options
      )
      unless result.success?
        raise ShippingServiceError.new("UpdateStripeCheckout", result.errors)
      end
    end
  end
end
