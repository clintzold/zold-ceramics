class DropCustomersTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :orders
    drop_table :customers
  end
end
