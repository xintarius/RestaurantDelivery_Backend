class CreateUserPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :user_payments do |t|
      t.references :user, foreign_key: true
      t.integer :prace_per_order
      t.integer :gross_payment
      t.integer :net_payment
      t.numeric :vat
      t.timestamps
    end
  end
end
