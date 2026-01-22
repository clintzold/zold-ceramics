# app/services/shipping_services/generate_options.rb
module ShippingService
  class GenerateOptions < ApplicationService
    def initialize(shipping_details:, session_id:, order_items:)
      @session_id = session_id
      @shipping_details = shipping_details
      @order_items = order_items
      @shipment = nil
      @rates = nil
      @shipping_options = nil
    end

    def call
      build_shipment

      get_rates

      build_shipping_options

      update_stripe_checkout

      success()
    rescue ShippingServiceError => e
      failure(e.message)
    end

    private

    def build_shipment
      result = ShippingService::BuildShipment.call(
        shipping_details: @shipping_details,
        order_items: @order_items
      )

      if result.success?
       @shipment = result.payload
      else
        raise ShippingServiceError.new("BuildShipment", result.errors)
      end
    end

    def get_rates
      result = ShippingService::GetRates.call(@shipment)

      if result.success?
        @rates = result.payload
      else
        raise ShippingServiceError.new("GetRates", result.errors)
      end
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
