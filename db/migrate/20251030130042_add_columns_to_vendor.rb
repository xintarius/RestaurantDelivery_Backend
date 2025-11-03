class AddColumnsToVendor < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :nip, :string
    add_column :vendors, :activated_in_system, :boolean, default: false
  end
end
