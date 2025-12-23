# app/services/order_service/paid.rb
module OrderService
  class Paid < ApplicationService
    def initialize(order_id:, order_details:)
      @order = nil
      @order_id = order_id
      @order_details = order_details
    end

    def call
      retrieve_order

      add_details_to_paid_order

      save_order
    end

    private

    def retrieve_order
      @order = Order.find(@order_id)
    end

    def add_details_to_paid_order
      @order.assign_attributes(
        stripe_order_id: @order_details.id,
        stripe_customer_id: @order_details.customer,
        shipping_address: @order_details.customer_details.address,
        email: @order_details.customer_details.email,
        name: @order_details.customer_details.name,
        sub_total: @order_details.amount_total.to_i / 100,
        total: @order_details.amount_total.to_i / 100,
        shipping_rate: @order_details.shipping_cost.shipping_rate,
        status: 1
      )
    end

    def save_order
      @order.save!
    end
  end
end
