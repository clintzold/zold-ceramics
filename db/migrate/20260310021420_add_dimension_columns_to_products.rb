class AddDimensionColumnsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :length, :decimal
    add_column :products, :width, :decimal
    add_column :products, :height, :decimal
    add_column :products, :weight, :integer
  end
end
