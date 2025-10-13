class CreateVendorPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :vendor_payments do |t|
      t.references :vendor, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :price_per_order
      t.integer :gross_payment
      t.integer :net_payment
      t.numeric :vat
      t.timestamps
    end
  end
end
