class Create < ActiveRecord::Migration[8.0]
  def change
    create_table :terminals do |t|
      t.time :hour_from
      t.time :hour_to
      t.integer :courier_limit
      t.timestamps
    end
  end
end
