class DropReservationTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :reservations
  end
end
