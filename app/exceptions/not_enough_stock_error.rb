# app/exceptions/not_enough_stock_error.rb
class NotEnoughStockError < StandardError
  def initialize(product_name, quantity_left)
    @message = "Too slow! Not enough stock for #{product_name}. Only #{quantity_left} remaining."
    super(@message)
  end
end
