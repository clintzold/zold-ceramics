class Product < ApplicationRecord
  validates :title, :description, :price, :stock, presence: true
  # Triggered actions
  after_update :check_out_of_stock
  after_update :update_stripe_product
  after_update :update_stripe_price
  before_destroy :archive_stripe_product, prepend: true
  # Product table DB associations
  has_many :cart_items, dependent: :destroy
  has_many :order_items
  # Create thumbnail variants of product images
  has_one_attached :main_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end

  private

  # Toggles out-of-stock state of products
  def check_out_of_stock
    if self.stock < 1
      self.update!(out_of_stock: true)
    elsif self.stock > 0 && self.out_of_stock
      self.update!(out_of_stock: false)
    else
      nil
    end
  end
  # Updates name and description of product if change has occurred
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
  # Adds new price object to Stripe account
  def update_stripe_price
    return unless stripe_product_id.present?
    begin
      if saved_change_to_price?
        new_price = Stripe::Price.create({  # Creates a new Price object
          product: stripe_product_id,
          unit_amount: (price * 100).to_i,
          currency: "cad"
        })
        Stripe::Product.update( # Syncs new price with specified Product object
          stripe_product_id,
          { default_price: new_price.id }
        )
        if stripe_price_id.present? # Sets old Price object to false
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
  # Handles archiving of synced Stripe products that have been deleted from DB
  def archive_stripe_product
    return unless stripe_product_id.present? # Prevent interruption of #destroy when products have no valid Stripe id (for development purposes)
    begin
      Stripe::Product.update(
        stripe_product_id,
        { active: false }
      )
      puts "Stripe product #{stripe_product_id} was archived."
      true
    rescue Stripe::InvalidRequestError => e
      puts "Error archiving Stripe product #{stripe_product_id}: #{e.message}"
      false
    end
  end
end
