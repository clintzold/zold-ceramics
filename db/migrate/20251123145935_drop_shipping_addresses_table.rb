class DropShippingAddressesTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :shipping_addresses
  end
end
