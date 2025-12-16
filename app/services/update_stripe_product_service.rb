class UpdateStripeProductService
  def initialize(product)
    @stripe_product_id = product.stripe_product_id
    @name = product.title
    @description = product.description
  end

  def call
    begin
      Stripe::Product.update(
        @stripe_product_id,
        {
          name: @name,
          description: @description
        })
    rescue Stripe::StripeError => e
      Rails.logger.error("Failed to update Stripe Product: #{@stripe_product_id}, error: #{e.message}")
    end
  end
end
