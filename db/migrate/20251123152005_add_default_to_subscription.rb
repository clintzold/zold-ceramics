class AddDefaultToSubscription < ActiveRecord::Migration[8.1]
  def change
    change_column_default :customers, :subscription, from: nil, to: false
  end
end
