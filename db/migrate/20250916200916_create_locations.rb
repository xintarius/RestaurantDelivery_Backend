class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :region_name
      t.string :longitude
      t.string :latitude
      t.timestamps
    end
  end
end
