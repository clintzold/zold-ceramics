class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :shipping_address
      t.jsonb :product

      t.timestamps
    end
  end
end
