class RemoveOrdersFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_reference :orders, :product, foreign_key: true
  end
end
