class Order < ApplicationRecord
  enum :status, { pending: 0, paid: 1, canceled: 2 }
  belongs_to :user
  has_many :order_items, dependent: :destroy
  after_update :check_status


  private

  def check_status
    if saved_change_to_status? && status == "canceled"
     return_stock
    end
  end

  def return_stock
    retries = 0
    order_items.each do |item|
      begin
        product = Product.find(item.product_id)
        product.increment!(:stock, item.quantity)
      rescue ActiveRecord::StaleObjectError
        product.reload
        product.increment!(:stock, item.quantity)
        retries += 1
        if retries < 3
          retry
        else
          puts "Return stock failed 3 times"
          Rails.logger.error "Failed to return stock to item '#{item.product.id}' on order '#{self.id}'"
          raise
        end
      end
    end
  end
end
