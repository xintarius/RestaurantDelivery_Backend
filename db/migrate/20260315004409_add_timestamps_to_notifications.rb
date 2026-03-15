class AddTimestampsToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :timestamp, :datetime
  end
end
