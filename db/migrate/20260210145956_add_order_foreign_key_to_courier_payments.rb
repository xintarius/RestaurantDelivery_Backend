class AddOrderForeignKeyToCourierPayments < ActiveRecord::Migration[8.0]
  def change
    add_reference :courier_payments, :order, foreign_key: true
  end
end
