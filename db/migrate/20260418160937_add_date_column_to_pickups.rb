class AddDateColumnToPickups < ActiveRecord::Migration[8.1]
  def change
    add_column :pickups, :date, :date
  end
end
