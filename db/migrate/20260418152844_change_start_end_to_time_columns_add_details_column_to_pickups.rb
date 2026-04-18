class ChangeStartEndToTimeColumnsAddDetailsColumnToPickups < ActiveRecord::Migration[8.1]
  def change
    add_column :pickups, :details, :text
    change_column :pickups, :start, :time
    change_column :pickups, :end, :time
  end
end
