class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :location, foreign_key: true
      t.references :user, foreign_key: true
      t.string :city
      t.string :postal_code
      t.string :postal_city
      t.string :street
      t.string :building
      t.string :apartment
      t.timestamps
    end
  end
end
