class DropOrderTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :orders
  end
end
