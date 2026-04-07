class AddLocalColumnToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :local, :boolean, default: false, null: false
  end
end
