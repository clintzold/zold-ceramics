class CreateJoinTablePickupsOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :pickups_orders, id: false do |t|
      t.belongs_to :pickup
      t.belongs_to :order
    end
  end
end
