class AddVendorIdToCartSummary < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_summaries, :vendor_id, :integer
  end
end
