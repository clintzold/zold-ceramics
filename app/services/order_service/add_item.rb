# app/services/order_service/add_item.rb
#
# This service uses pessimistic locking for
# database operations.
#
# Having such limited stock of sometimes 'one-off' products
# means that extra measures must be in place to prevent
# over-ordering.
#
# High competition for products is anticipated but not
# such volume of traffic as to create a dead-lock.
#
# This service should be refactored to rescue dead-lock
# situations or a reservation system implemented if traffic
# begins to reach critical levels.
#
# ERRORS:
# Errors must be allowed to 'bubble-up' and the ServiceResult struct
# remain un-used. No success or failure check occurs during order
# creation service calling this AddItem, instead errors are
# rescued in OrderService::Create and passed through to Order
# Controller for a success check.
#
module OrderService
  class AddItem < ApplicationService
    def initialize(order:, product_id:, desired_amount:)
      @order = order
      @product = Product.find(product_id)
      @desired_amount = desired_amount
    end

    def call
      @product.with_lock do
        @product.reload
        if stock_available?
          @product.stock -= @desired_amount
          @product.save!
          add_item_to_order
        else
          raise NotEnoughStockError.new(@product.title, @product.stock)
        end
      end
    end

    private

    def stock_available?
      @product.stock >= @desired_amount
    end

    def add_item_to_order
      @order.order_items.new(
        product_id: @product.id,
        quantity: @desired_amount,
        price: @product.price
      )
    end
  end
end
