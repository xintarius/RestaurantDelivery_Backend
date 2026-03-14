class CreateNotificationRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_roles do |t|
      t.string :notification
      t.string :role

      t.timestamps
    end
  end
end
