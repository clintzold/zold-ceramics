# app/services/shipping_services/build_shipment.rb
module ShippingService
  class BuildShipment < ApplicationService
    def initialize(shipping_details:, order_items:)
      @name = shipping_details["name"]
      @address = shipping_details["address"]
      @order_items = order_items
      @parcels = []
      @shipment = nil
    end

    def call
      create_parcels

      create_shipment

      success(@shipment)
    rescue StandardError => e
      failure(e.message)
    end

    def create_parcels
      @order_items.each do
        @parcels << {
        "length" => "5",
        "width" => "5",
        "height" => "5",
        "distance_unit" => "in",
        "weight" => "2",
        "mass_unit" => "lb"
        }
      end
    end

    def create_shipment
      @shipment = {
      "address_from" => {
        "name" => "Clint Zold",
        "street1" => "456 County Rd 42",
        "city" => "Windsor",
        "state" => "ON",
        "zip" => "N8N 2L9",
        "country" => "CA"
      },
      "address_to" => {
        "name" => @name,
        "street1" => @address["line1"],
        "street2" => @address["line2"],
        "city" => @address["city"],
        "state" => @address["state"],
        "zip" => @address["postal_code"],
        "country" => @address["country"]
      },
      "parcels" => @parcels
    }
    end
  end
end
