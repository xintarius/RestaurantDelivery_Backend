class FixNotificationRolesColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :notification_roles, :notification, :string
    remove_column :notification_roles, :role, :string

    add_reference :notification_roles, :notification, null: false, foreign_key: true
    add_reference :notification_roles, :role, null: false, foreign_key: true
  end
end
