class AddCurrentBalanceInCouriers < ActiveRecord::Migration[8.0]
  def change
    add_column :couriers, :current_balance, :integer, default: 0
  end
end
