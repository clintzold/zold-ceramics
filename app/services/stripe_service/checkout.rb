# app/services/stripe_checkout_service.rb
module StripeService
  class Checkout < ApplicationService
    include Rails.application.routes.url_helpers
    def initialize(order_id:, line_items:, customer_email: nil, success_url:)
      @success_url = success_url
      @line_items = line_items
      @customer_email = customer_email
      @order_id = order_id
    end

    def call
      begin
        @session = Stripe::Checkout::Session.create({
          ui_mode: "embedded",
          permissions: { update_shipping_details: "server_only" },
          payment_method_types: [ "card" ],
          line_items: @line_items,
          mode: "payment",
          customer_creation: "always",
          automatic_tax: { enabled: true },
          shipping_address_collection: { allowed_countries: [ "CA" ] },
          shipping_options: [ {
            shipping_rate_data: {
              display_name: "Dummy shipping",
              type: "fixed_amount",
              fixed_amount: {
                amount: 0,
                currency: "cad"
              }
            }
          } ],
          return_url: @success_url + "?session_id={CHECKOUT_SESSION_ID}",
          expires_at: (Time.now + 30.minutes).to_i,
          metadata: { order_id: @order_id },
          payment_intent_data: { metadata: { order_id: @order_id } }
        })
        @session
      rescue Stripe::StripeError => e
        # Handle Stripe API errors
        Rails.logger.error "Stripe API Error: #{e.message}"
      end
    end
  end
end
