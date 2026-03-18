class ChangeShippingTotalToDecimalsOrdersTable < ActiveRecord::Migration[8.1]
  def change
    change_column :orders, :shipping_total, :decimal
  end
end
