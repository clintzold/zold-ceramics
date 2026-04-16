class CreatePickups < ActiveRecord::Migration[8.1]
  def change
    create_table :pickups do |t|
      t.datetime :start
      t.datetime :end
      t.string :link
      t.string :location

      t.timestamps
    end
  end
end
