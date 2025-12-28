# app/exceptions/create_shipment_error.rb
class ShippingServiceError < StandardError
  def initialize(service, message)
    @message = "An error occured during shipment creation: #{service} with message: #{message}"
    super(@message)
  end
end
