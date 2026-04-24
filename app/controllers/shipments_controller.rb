class ShipmentsController < ApplicationController
  before_action :verify_token

  def process_webhook
    order_id = params[:data][:metadata].split(" ").last
    updated_status = params[:tracking_status][:status].downcase
    puts order_id
    puts updated_status
    # @order = Order.find(order_id)
    # @order.update(status: updated_status)
    head :ok
  end


  private

  def verify_token
    server_token = Rails.application.credentials.dig(:shippo, :webhook_token)
    request_token = params[:token]
    unless ActiveSupport::SecurityUtils.secure_compare(request_token, server_token)
      head :unauthorized
    end
  end
end
