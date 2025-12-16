class CheckoutSessionProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook_event)
    begin
      # Parse payload from stored WebhookEvent
      payload = JSON.parse(webhook_event.payload)
      # Construct event from DB instead of HTTP request
      # to Stripe(save 200 ms!)
      event = Stripe::Event.construct_from(payload)
      event_details = event.data.object
      order_id = event_details.metadata.order_id

      case event.type
      when "checkout.session.completed"
        update_order_paid(order_details: event_details)
        webhook_event.toggle!(:processed)
      when "checkout.session.expired"
        CancelOrderService.new(order_id).call
        webhook_event.toggle!(:processed)
      end
    rescue StandardError => e
      Rails.logger.error "Error processing webhook event: #{e.message}"
    end
  end

  private

  def update_order_paid(order_details:)
      order = Order.find(order_details.metadata.order_id)
      order.update!(
        stripe_order_id: order_details.id,
        stripe_customer_id: order_details.customer,
        shipping_address: order_details.customer_details.address,
        email: order_details.customer_details.email,
        name: order_details.customer_details.name,
        sub_total: order_details.amount_total.to_i / 100,
        total: order_details.amount_total.to_i / 100,
        shipping_rate: order_details.shipping_cost.shipping_rate,
        status: 1
      )
  end
end
