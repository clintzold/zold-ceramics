# app/services/order_service/paid.rb
module OrderService
  class Paid < ApplicationService
    def initialize(checkout_details)
      @order = nil
      @order_id = checkout_details.metadata.order_id
      @checkout_details = checkout_details
      @shipping_rate = nil
    end

    def call
      retrieve_order

      # Must retrieve Stripe Shipping Rate created at checkout to access
      # metadata that contatins the Shippo Shipping Rate ID.
      #
      # Shippo Shipping Rate ID is necessary for purchasing the proper
      # shipping label for the Order and shipping rate purchased by
      # the customer.
      retrieve_shipping_rate

      add_details_to_paid_order

      save_order
    end

    private

    def retrieve_order
      @order = Order.find(@order_id)
    end

    def add_details_to_paid_order
      @order.assign_attributes(
        stripe_order_id: @checkout_details.id,
        stripe_customer_id: @checkout_details.customer,
        shipping_address: @checkout_details.customer_details.address,
        email: @checkout_details.customer_details.email,
        name: @checkout_details.customer_details.name,
        sub_total: @checkout_details.amount_subtotal.to_d / 100,
        total: @checkout_details.amount_total.to_d / 100,
        shipping_rate: @shipping_rate,
        shipping_total: @checkout_details.shipping_cost.amount_total.to_d / 100,
        status: 1
      )
    end

    def retrieve_shipping_rate
      rate = Stripe::ShippingRate.retrieve(@checkout_details.shipping_cost.shipping_rate)
     @shipping_rate = rate.display_name
    end

    def save_order
      @order.save!
    end
  end
end
