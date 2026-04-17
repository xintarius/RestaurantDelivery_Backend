class AddLimitationsToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :paused_until, :datetime
    add_column :vendors, :max_active_orders, :integer
  end
end
