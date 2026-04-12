class ReplaceDeliveryTimeWithEstimatedReadyColumnInOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :delivery_time, :integer
    add_column :orders, :estimated_delivery_time, :datetime
  end
end
