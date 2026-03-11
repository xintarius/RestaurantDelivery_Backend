class CreateZones < ActiveRecord::Migration[8.0]
  def change
    create_table :zones do |t|
      t.references :location, null: false, foreign_key: true
      t.string :name
      t.jsonb :polygon_path, default: []
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
