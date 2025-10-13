class RemoveOrderIdFromCouriers < ActiveRecord::Migration[8.0]
  def change
    remove_column :couriers, :orders_id, foreign_key: true
  end
end
