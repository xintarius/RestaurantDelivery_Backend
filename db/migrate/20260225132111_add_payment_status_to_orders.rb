class AddPaymentStatusToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :payment_status, :string, default: 'unpaid'
  end
end
