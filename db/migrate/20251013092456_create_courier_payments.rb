class CreateCourierPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :courier_payments do |t|
      t.references :courier, foreign_key: true
      t.references :order, foreign_key: true
      t.references :courier_trace, foreign_key: true
      t.integer :gross_payment
      t.integer :net_payment
      t.numeric :vat
      t.string :kilometer_distance
      t.timestamps
    end
  end
end
