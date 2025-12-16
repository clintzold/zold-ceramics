class CancelOrderService
  def initialize(order_id)
    @order = Order.find(order_id)
  end

  def call
    cancel_order
    restock_products
  end

  private

  def restock_products
    @order.order_items.each do |item|
      product = Product.find(item.product_id)
      begin
        product.with_lock do
          product.reload
          product.increment!(:stock, item.quantity)
        end
      rescue StandardError => e
        Rails.logger.error "An error occurred during restock: #{e.message}"
      end
    end
  end

  def cancel_order
    begin
    @order.update!(status: 2)
    rescue StandardError => e
      Rails.logger.error "Error canceling order: #{e.message}"
    end
  end
end
