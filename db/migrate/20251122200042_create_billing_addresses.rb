class CreateBillingAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_addresses do |t|
      t.string :name
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :city
      t.string :province

      t.timestamps
    end
  end
end
