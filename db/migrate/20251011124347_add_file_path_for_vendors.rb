class AddFilePathForVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :file_path, :string
  end
end
