# app/services/stripe_service/update_product.rb
module StripeService
  class UpdateProduct < ApplicationService
    def initialize(product)
      @stripe_product_id = product.stripe_product_id
      @name = product.title
      @description = product.description
    end

    def call
      Stripe::Product.update(
        @stripe_product_id,
        {
          name: @name,
          description: @description
        })
    rescue Stripe::StripeError => e
      Rails.logger.error("Error updating Stripe product: #{e.message}")
    end
  end
end
