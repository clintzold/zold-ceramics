# app/services/order_service/cancel.rb
module OrderService
  class Cancel < ApplicationService
    def initialize(order_id)
      @order = nil
      @order_id = order_id
    end

    def call
      retrieve_order

      cancel_order

      restock_products
    end

    private

    def retrieve_order
      @order = Order.find(@order_id)
    end

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
