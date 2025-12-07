# app/services/order_service.rb

class OrderService
  def initialize(user:)
    @user = user
    @cart = user.cart
    @order = nil
    @error = nil
  end

  def call
    create_order!
  end

  def errors
    @error
  end

  def order
    @order
  end

  def success?
    @error.nil?
  end

  private

  def create_order!
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: @user.id)

      @cart.cart_items.each do |item|
        puts @user.email
        product = Product.find(item.product_id)
        product.with_lock do
          product = Product.find(item.product_id)
          if product.stock >= item.quantity
            product.decrement!(:stock, item.quantity)
            order.order_items.create!(product_id: item.product_id, quantity: item.quantity, price: product.price)
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
