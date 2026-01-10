class ChangeCategoryToStringOnProductsTable < ActiveRecord::Migration[8.1]
  def change
    change_column :products, :category, :string
  end
end
