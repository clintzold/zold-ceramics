class AddNameToSubscriptionsTable < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :name, :string
  end
end
