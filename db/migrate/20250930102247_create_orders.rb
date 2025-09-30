class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :products, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :user, foreign_key: true
      t.string :order_status, default: 'pending'
      t.string :order_note_vendor
      t.string :order_note_courier
      t.string :order_number
      t.timestamps
    end
  end
end
