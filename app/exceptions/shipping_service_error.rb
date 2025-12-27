# app/exceptions/shipping_service_error.rb
class ShippingServiceError < StandardError
  def initialize(service, message)
    @message = "An error occured during Shipping Service: #{message}"
    super(@message)
  end
end
