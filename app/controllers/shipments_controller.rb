class ShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token

  def process_webhook
    @event = params
    WebhookEvent.create(payload: @event)
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
