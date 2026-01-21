class Product < ApplicationRecord
  validates :title, :category, :description, :price, :stock, presence: true

  after_update :check_out_of_stock
  after_update :update_stripe_product
  after_update :update_stripe_price
  before_destroy :archive_stripe_product, prepend: true

  has_many :cart_items, dependent: :destroy
  has_many :order_items
  has_one_attached :main_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
    attachable.variant :card_image, resize_to_limit: [ 500, 500 ]
  end
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
    attachable.variant :card_image, resize_to_limit: [ 500, 500 ]
  end


  private

  # Toggles out-of-stock state of products
  def check_out_of_stock
    if self.stock < 1 && !self.out_of_stock

      self.update!(out_of_stock: true)

    elsif self.stock > 0 && self.out_of_stock

      self.update!(out_of_stock: false)

    else
      nil
    end
  end

  # Updates title and description of product if change has occurred
  def update_stripe_product
    return unless stripe_product_id.present?
    if saved_change_to_title? || saved_change_to_description?
      StripeService::UpdateProduct.call(self)
    end
  end

  # Adds new price object to Stripe product if change detected
  def update_stripe_price
    return unless stripe_product_id.present?
    if saved_change_to_price?
      StripeService::UpdatePrice.call(self)
    end
  end

  # Archives Stripe Product (triggered on destroy)
  def archive_stripe_product
    Stripe::Product.update("#{self.stripe_product_id}", { active: false })
  rescue Stripe::StripeError => e
    Rails.logger.error "Error archiving Stripe Product: #{e.message}"
  end
end
