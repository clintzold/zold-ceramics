class AddColumnsToCustomer < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :name, :string
    add_column :customers, :phone, :integer
  end
end
