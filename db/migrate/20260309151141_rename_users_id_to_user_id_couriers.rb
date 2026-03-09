class RenameUsersIdToUserIdCouriers < ActiveRecord::Migration[8.0]
  def change
    rename_column :couriers, :users_id, :user_id
  end
end
