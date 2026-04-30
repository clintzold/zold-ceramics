# app/services/order_service/cancel.rb
module OrderService
  class Cancel < ApplicationService
    def initialize(order_token)
      @order = Order.find_by(token: order_token)
    end

    def call
      restock_products

      cancel_order
    end

    private

    def restock_products
      @order.order_items.each do |item|
        product = Product.find(item.product_id)
          product.with_lock do
            product.reload
            product.update(:stock, item.quantity)
        end
      end
    end

    def cancel_order
      @order.destroy
    end
  end
end
