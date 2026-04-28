class AddOuncesColumnToProductsTable < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :ounces, :integer
  end
end
