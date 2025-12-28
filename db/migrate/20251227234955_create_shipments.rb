class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :tracking_number
      t.string :tracking_status
      t.string :tracking_url_provider
      t.string :label_url
      t.string :parcel

      t.timestamps
    end
  end
end
