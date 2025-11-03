class CreateNotificationUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_users do |t|
      t.references :user, foreign_key: true
      t.references :notification, foreign_key: true
      t.timestamps
    end
  end
end
