class AddCategoryTypeIdToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :category_type_id, :integer
  end
end
