class CreateCouriers < ActiveRecord::Migration[8.0]
  def change
    create_table :couriers do |t|
      t.references :users, foreign_key: true
      t.references :orders, foreign_key: true
      t.references :addresses, foreign_key: true
      t.references :locations, foreign_key: true
      t.references :roles, foreign_key: true
      t.string :courier_status, default: 'Offline'
      t.string :courier_code
      t.string :vehicle_type
      t.timestamps
    end
  end
end
