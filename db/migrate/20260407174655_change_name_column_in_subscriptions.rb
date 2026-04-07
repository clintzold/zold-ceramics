class ChangeNameColumnInSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :last_name, :string
    rename_column :subscriptions, :name, :first_name
  end
end
