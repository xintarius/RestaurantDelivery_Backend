class RenameProductsIdToProduct < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :products_id, :product_id
  end
end
