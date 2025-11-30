class DropProductReservationTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :product_reservations
  end
end
