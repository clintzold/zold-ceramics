class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :reserved_quantity
      t.datetime :expires_at

      t.timestamps
    end
  end
end
