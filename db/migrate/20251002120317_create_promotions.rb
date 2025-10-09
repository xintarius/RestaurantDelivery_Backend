class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.references :products
      t.string :promo_value_reduction
      t.string :promo_value_vendor_reduction
      t.timestamps
    end
  end
end
