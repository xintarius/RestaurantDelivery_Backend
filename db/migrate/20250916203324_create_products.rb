class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :vendor, foreign_key: true
      t.string :product_name
      t.integer :amount, default: 1
      t.decimal :price_gross
      t.decimal :price_net
      t.timestamps
    end
  end
end
