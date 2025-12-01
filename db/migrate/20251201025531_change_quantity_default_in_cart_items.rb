class ChangeQuantityDefaultInCartItems < ActiveRecord::Migration[8.1]
  def change
    change_column_default :cart_items, :quantity, from: nil, to: 0
  end
end
