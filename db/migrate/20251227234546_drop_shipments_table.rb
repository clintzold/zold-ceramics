class DropShipmentsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :shipments
  end
end
