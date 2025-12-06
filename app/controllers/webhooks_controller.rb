class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token # External data will not have token from our app

  # Create a new webhook event and save to DB upon POST request
  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil
    # Construct Stripe event from JSON dump
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.stripe[:webhook_secret]
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: "Invalid signature" }, status: 400
      return
    end
    # Handle the event based on its type
    case event.type
    when "checkout.session.completed"
      # Handle commpleted checkout
      WebhookEvent.create!(payload: payload, headers: sig_header)
    # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end
    # Stripe waits for 200 'ok' response from our server. If not received they will send Webhook again
    render json: { message: "success" }, status: 200
  end
end
