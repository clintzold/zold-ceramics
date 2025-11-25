class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

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
    when "customer.created"
      # Handle customer created event
      puts "Customer created: #{event.data.object.id}"
    when "payment_intent.succeeded"
      # Handle successful payment intent
      puts "Payment Intent succeeded: #{event.data.object.id}"
    # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: "success" }, status: 200
  end

  def show
  end
end
