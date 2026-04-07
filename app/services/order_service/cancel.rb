# app/services/order_service/cancel.rb
module OrderService
  class Cancel < ApplicationService
    def initialize(order_token)
      @order = Order.find_by(token: order_token)
    end

    def call
      cancel_order

      restock_products
    end

    private

    def restock_products
      @order.order_items.each do |item|
        product = Product.find(item.product_id)
          product.with_lock do
            product.reload
            product.increment!(:stock, item.quantity)
        end
      end
    end

    def cancel_order
      @order.update!(status: 2)
    end
  end
end
