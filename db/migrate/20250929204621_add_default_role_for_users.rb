class AddDefaultRoleForUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role_id, default: 2
  end
end
