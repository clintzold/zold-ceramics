class CreateShippingAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_addresses do |t|
      t.string :name
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :city
      t.string :province
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
