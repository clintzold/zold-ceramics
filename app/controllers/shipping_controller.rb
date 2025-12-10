class ShippingController < ApplicationController
  skip_before_action :verify_authenticity_token
  def test
  end

  def get_rates
    address_from = {
      "name" => "Clint Zold",
      "street1" => "456 County Rd 42",
      "city" => "Windsor",
      "state" => "ON",
      "zip" => "N8N 2L9",
      "country" => "CA"
    }

    address_to = {
      "name" => "Simone Shepley",
      "street1" => "2-4603 Ryders Ridge Blvd",
      "city" => "Sylvan Lake",
      "state" => "AB",
      "zip" => "T4S 0G6",
      "country" => "CA"
    }

    parcels = [ {
      "length" => "5",
      "width" => "5",
      "height" => "5",
      "distance_unit" => "in",
      "weight" => "2",
      "mass_unit" => "lb"
    } ]

    request = ShippoCreateShipmentService.new(address_from: address_from, address_to: address_to, parcels: parcels)
    request.call
    render :test
  end
end
