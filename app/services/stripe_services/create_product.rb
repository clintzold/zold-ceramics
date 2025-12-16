module StripeService
  class CreateProduct
    def initialize(product)
      @product = product
      @error = nil
    end

    def call
      create_stripe_product_and_price
    end

    def success?
      @error.nil?
    end

    def error
      @error
    end

    private

    def create_stripe_product_and_price
      begin
        stripe_product = Stripe::Product.create({
          name: @product.title,
          description: @product.description
        })
        stripe_price = Stripe::Price.create({
          unit_amount: (@product.price * 100).to_i, # Float must be converted to Integer for Stripe processing
          currency: "cad",
          product: stripe_product.id
        })
        @product.update!(
          stripe_product_id: stripe_product.id,
          stripe_price_id: stripe_price.id
        )
      rescue StandardError => e
        @error = e.message
        Rails.logger.error "There was an error creating Stripe product: #{e.message}"
      end
    end
  end
end
