class CreateCalendars < ActiveRecord::Migration[8.0]
  def change
    create_table :calendars do |t|
      t.date :date
      t.integer :weekday
      t.string :timeline_nr
      t.integer :year
      t.timestamps
    end

    add_index :calendars, :date, unique: true
  end
end
