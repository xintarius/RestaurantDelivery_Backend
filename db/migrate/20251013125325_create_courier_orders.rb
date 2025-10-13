class CreateCourierOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :courier_orders do |t|
      t.references :courier, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
    add_index :courier_orders, [:courier_id, :order_id], unique: true
  end
end
