# app/services/order_service.rb

class OrderService
  def initialize(cart:)
    @cart = cart
    @order = nil
    @error = nil
    @order_id = nil
  end

  def call
    create_order!
  end
  # Returns error message if Order creation transaction fails
  def errors
    @error
  end
  # Boolean check for error and failure of order creation
  def success?
    @error.nil?
  end
  # Retrieve ID of newly created order
  def order_id
    @order_id
  end
  private

  def create_order!
    # All changes rolled back if any step fails
    ActiveRecord::Base.transaction do
      order = Order.create!

      @cart.cart_items.each do |item|
        # Lock product row to prevent race conditions
        Product.find(item.product_id).with_lock do
          # Ensure latest record details are used
          product = Product.find(item.product_id)
          # Check if enough stock is available and handle accordingly
          if product.stock >= item.quantity
            # Atomic DB operation to avoid concurrency issues
            product.decrement!(:stock, item.quantity)
            # Add item to order
            order.order_items.create!(product_id: item.product_id, quantity: item.quantity, price: product.price)
            # Retrieve ID of pending order
            @order_id = order.id
          else
            raise StandardError.new("Not enough stock for #{product.title}. Only #{product.stock} remaining.")
          end
        end
      end
      order
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Transaction was not completed: #{e.message}"
    @error = "Order not created: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "An error occurred during order creation: #{e.message}"
    @error = "Order canceled: #{e.message}"
  end
end
