class CreateTerminalCalendars < ActiveRecord::Migration[8.0]
  def change
    create_table :terminal_calendars do |t|
      t.references :terminal, foreign_key: true
      t.references :calendars, foreign_key: true
      t.timestamps
    end
  end
end
