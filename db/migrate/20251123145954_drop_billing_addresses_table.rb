class DropBillingAddressesTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :billing_addresses
  end
end
