class AddCategoryToProductsTable < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :category, :integer
  end
end
