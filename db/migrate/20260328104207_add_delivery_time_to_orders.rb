class AddDeliveryTimeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :delivery_time, :integer
    add_column :orders, :reject_reason, :string
  end
end
