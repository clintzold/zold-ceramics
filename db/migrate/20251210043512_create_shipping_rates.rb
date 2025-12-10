class CreateShippingRates < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_rates do |t|
      t.jsonb :body
      t.timestamps
    end
  end
end
