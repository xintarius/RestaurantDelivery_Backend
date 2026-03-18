class CreateHistoryOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :history_orders do |t|
      t.string :restaurant_name
      t.string :pickup_address
      t.string :delivery_address
      t.integer :total_courier_earnings
      t.integer :base_earnings_data
      t.string :order_status
      t.references :order
      t.references :courier
      t.references :vendor
      t.timestamps
    end
  end
end
