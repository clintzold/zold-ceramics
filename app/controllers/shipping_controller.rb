class ShippingController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get_shipping_options
    begin
      shipping_details = params[:shipping_details]
      session_id = params[:checkout_session_id]

      order_items = retrieve_order_items(session_id)
      rates = create_shipment(shipping_details: shipping_details, order_items: order_items)
      shipping_options = create_shipping_options(rates)

      update_stripe_checkout(
        checkout_session_id: session_id,
        shipping_details: shipping_details,
        shipping_options: shipping_options
      )
    rescue StandardError => e
      Rails.logger.error "There was an error retrieving shipping options: #{e.message}"
    end
  end

  private

  def retrieve_order_items(session_id)
    session = Stripe::Checkout::Session.retrieve(session_id)
    order = Order.find(session.metadata.order_id)
    order_items = order.order_items
    order_items
  end

  def create_shipping_options(rates)
    options = []
    rates.each do |rate|
      options << {
        shipping_rate_data: {
          display_name: rate["servicelevel"]["display_name"],
          type: "fixed_amount",
          fixed_amount: {
            currency: rate["currency_local"],
            amount: (rate["amount_local"].to_i * 100).to_s
          }
        }
      }
    end
    options
  end

  def update_stripe_checkout(checkout_session_id:, shipping_details:, shipping_options:)
    address_details = shipping_details["address"]
    Stripe::Checkout::Session.update(checkout_session_id, {
      collected_information: {
        shipping_details: {
          name: shipping_details["name"],
          address: {
            line1: address_details["line1"],
            line2: address_details["line2"],
            city: address_details["city"],
            country: address_details["country"],
            state: address_details["state"],
            postal_code: address_details["postal_code"]
          }
        }
      },
      shipping_options: shipping_options
    })
    { type: "object", value: { succeeded: true } }.to_json
  end

  def create_shipment(shipping_details:, order_items:)
    address = shipping_details["address"]
    parcels = []
    order_items.each do
      parcels << {
      "length" => "5",
      "width" => "5",
      "height" => "5",
      "distance_unit" => "in",
      "weight" => "2",
      "mass_unit" => "lb"
    }
    end

    # Create shipment object
    shipping_details = {
    "address_from" => {
      "name" => "Clint Zold",
      "street1" => "456 County Rd 42",
      "city" => "Windsor",
      "state" => "ON",
      "zip" => "N8N 2L9",
      "country" => "CA"
    },
    "address_to" => {
      "name" => shipping_details["name"],
      "street1" => address["line1"],
      "street2" => address["line2"],
      "city" => address["city"],
      "state" => address["state"],
      "zip" => address["postal_code"],
      "country" => address["country"]
    },
    "parcels" => parcels
  }

    request = ShippoCreateShipmentService.new(shipping_details: shipping_details)

    begin
      request.call
      if request.rates.any?
        request.rates
      else
        raise StandardError.new("Error during shipping rates request to Shippo: No rates retrieved!")
      end
    rescue StandardError => e
      Rails.logger.error "#{e.message}"
      retry
    end
  end
end
