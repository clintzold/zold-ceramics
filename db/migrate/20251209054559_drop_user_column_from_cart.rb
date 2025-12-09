class DropUserColumnFromCart < ActiveRecord::Migration[8.1]
  def change
    remove_column :carts, :user_id
  end
end
