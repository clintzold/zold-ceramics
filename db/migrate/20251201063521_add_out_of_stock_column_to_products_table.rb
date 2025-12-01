class AddOutOfStockColumnToProductsTable < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :out_of_stock, :boolean, default: false
  end
end
