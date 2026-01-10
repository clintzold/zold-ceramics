module ProductService
  class Create < ApplicationService
    def initialize(product)
      @product = product
      @stripe_product = nil
      @stripe_price = nil
    end

    def call
      # create_stripe_product

      # create_stripe_price

      # assign_stripe_attributes

      attempt_persist_new_product

    rescue Stripe::StripeError => e
      failure("An error occured with Stripe: #{e.message}")
    end

    private

    def create_stripe_product
      @stripe_product = Stripe::Product.create({
        name: @product.title,
        description: @product.description
      })
    end

    def create_stripe_price
      @stripe_price = Stripe::Price.create({
        unit_amount: (@product.price * 100).to_i, # float must be converted for Stripe processing
        currency: "cad",
        product: @stripe_product.id
      })
    end

    def assign_stripe_attributes
      @product.assign_attributes(
        stripe_product_id: @stripe_product.id,
        stripe_price_id: @stripe_price.id
      )
    end

    def attempt_persist_new_product
      if @product.save
        success(@product)
      else
        failure(@product.errors.full_messages)
      end
    end
  end
end
