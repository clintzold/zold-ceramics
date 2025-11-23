class DropOrderItemsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :order_items
  end
end
