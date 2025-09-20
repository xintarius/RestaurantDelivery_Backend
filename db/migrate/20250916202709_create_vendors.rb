class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.references :address, foreign_key: true
      t.references :user, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
