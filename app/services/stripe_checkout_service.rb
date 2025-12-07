# app/services/stripe_checkout_service.rb
class StripeCheckoutService
  include Rails.application.routes.url_helpers
  def initialize(line_items:, customer_email: nil, success_url:, cancel_url:)
    @success_url = success_url
    @cancel_url = cancel_url
    @line_items = line_items
    @customer_email = customer_email
  end

  def call
    # Begin Stripe checkout
    @session = Stripe::Checkout::Session.create({
      ui_mode: "embedded",
      payment_method_types: [ "card" ],
      line_items: @line_items,
      mode: "payment",
      automatic_tax: { enabled: true },
      shipping_address_collection: { allowed_countries: [ "CA" ] },
      return_url: @success_url + "?session_id={CHECKOUT_SESSION_ID}",
      expires_at: (Time.now + 30.minutes).to_i
    })
    @session
  rescue Stripe::StripeError => e
    # Handle Stripe API errors
    Rails.logger.error "Stripe API Error: #{e.message}"
  end
end
