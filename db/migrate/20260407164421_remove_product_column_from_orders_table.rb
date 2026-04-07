class RemoveProductColumnFromOrdersTable < ActiveRecord::Migration[8.1]
  def change
    remove_column :orders, :product
  end
end
