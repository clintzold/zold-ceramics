class ChangeTrackingStatusColumnToEnumShipmentsTable < ActiveRecord::Migration[8.1]
  def change
    remove_column :shipments, :tracking_status
    add_column :shipments, :tracking_status, :integer, default: 0
  end
end
