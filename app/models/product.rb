class Product < ApplicationRecord
  after_update :update_stripe_product
  after_update :update_stripe_price

  has_one_attached :main_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  validates :title, :description, :price, :stock, presence: true
  has_many :order_items


  private

  def update_stripe_product
    return unless stripe_product_id.present?
    begin
      if saved_change_to_attribute?(:title) || saved_change_to_attribute?(:description)
      Stripe::Product.update(
        stripe_product_id,
        {
          name: title,
          description: description
        }
      )
      end

    rescue Stripe::StripeError => e
      Rails.logger.error("Failed to update Stripe Product: #{e.message}")
    end
  end

  def update_stripe_price
    return unless stripe_product_id.present?
    begin
      if saved_change_to_price?
        new_price = Stripe::Price.create({
          product: stripe_product_id,
          unit_amount: (price * 100).to_i,
          currency: "cad"
        })

        Stripe::Product.update(
          stripe_product_id,
          { default_price: new_price.id }
        )

        if stripe_price_id.present?
          Stripe::Price.update(
            stripe_price_id,
            { active: false  }
          )
        end

          self.update(stripe_price_id: new_price.id)
      end

    rescue Stripe::StripeError => e
      Rails.logger.error("Failed to update Stripe Price: #{e.message}")
    end
  end
end
