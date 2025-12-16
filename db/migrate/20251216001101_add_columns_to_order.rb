class AddColumnsToOrder < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :stripe_order_id, :string
    add_column :orders, :stripe_customer_id, :string
    add_column :orders, :sub_total, :decimal
    add_column :orders, :total, :decimal
    add_column :orders, :shipping_rate, :string
  end
end
