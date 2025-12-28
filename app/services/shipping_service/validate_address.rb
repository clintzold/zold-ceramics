# app/services/shipping_service/validate_address.rb
module ShippingService
  class ValidateAddress < ApplicationService
    def initialize(address)
      @address = address
    end

    def call
    end
  end
end
