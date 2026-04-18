class AddAvailabilityToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :is_active, :boolean, default: false
    add_column :vendors, :std_open, :string, default: "09:00"
    add_column :vendors, :std_close, :string, default: "21:00"
  end
end
