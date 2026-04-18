class CreateVendorExceptions < ActiveRecord::Migration[8.0]
  def change
    create_table :vendor_exceptions do |t|
      t.references :vendor, null: false, foreign_key: true
      t.date :special_date, null: false
      t.string :exception_type
      t.string :open_time
      t.string :close_time
      t.string :note

      t.timestamps
    end
  end
end
