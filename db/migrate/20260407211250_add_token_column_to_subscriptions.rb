class AddTokenColumnToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :token, :string
    add_index :subscriptions, :token, unique: true
  end
end
