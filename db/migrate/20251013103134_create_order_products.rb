class CreateOrderProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :order_products do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity
      t.integer :unit_price
      t.integer :total_price
      t.timestamps
    end
  end
end
