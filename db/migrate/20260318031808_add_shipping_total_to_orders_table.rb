class AddShippingTotalToOrdersTable < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :shipping_total, :integer
  end
end
