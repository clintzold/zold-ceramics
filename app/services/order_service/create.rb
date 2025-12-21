# app/services/order_service.rb
module OrderService
  class Create < ApplicationService
    def initialize(cart:)
      @cart = cart
      @order = nil
    end

    def call
      ActiveRecord::Base.transaction do
        puts @cart
        create_order
        add_items_to_order
        @order.save!
      end

      success(@order)

    rescue NotEnoughStockError => e
      failure(e.message)
    rescue ActiveRecord::RecordNotFound => e
      failure(e.message)
    end

    private

    def create_order
      @order = Order.new
    end

    def add_items_to_order
      @cart.cart_items.each do |item|
        OrderService::AddItem.call(
          order: @order,
          product_id: item.product_id,
          desired_amount: item.quantity
        )
      end
    end
  end
end
