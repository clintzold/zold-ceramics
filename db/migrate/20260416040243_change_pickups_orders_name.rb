class ChangePickupsOrdersName < ActiveRecord::Migration[8.1]
  def change
    rename_table :pickups_orders, :orders_pickups
  end
end
