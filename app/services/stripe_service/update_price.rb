# app/services/stripe_service/update_price.rb
module StripeService
  class UpdatePrice < ApplicationService
    def initialize(product)
      @product = product
      @stripe_product_id = product.stripe_product_id
      @old_stripe_price_id = product.stripe_price_id
      @unit_amount = (product.price * 100).to_i
      @new_price = nil
    end
    def call
      create_new_price

      set_new_default_price

      archive_old_price

      update_product

    rescue Stripe::StripeError => e
      Rails.logger.error("Error updating Stripe Prices: #{e.message}")
    end

    private

    def create_new_price
      @new_price = Stripe::Price.create({  # Create new Price object
        product: @stripe_product_id,
        unit_amount: @unit_amount,
        currency: "cad"
      })
    end

    def set_new_default_price
      Stripe::Product.update( # Sync new price with specified Product object
        @stripe_product_id,
        { default_price: @new_price.id }
      )
    end

    def archive_old_price
      unless @old_stripe_price_id.nil? # Sets old Price object to false
        Stripe::Price.update(
          @old_stripe_price_id,
          { active: false  }
        )
      end
    end

    def update_product
     @product.update(stripe_price_id: @new_price.id)
    end
  end
end
