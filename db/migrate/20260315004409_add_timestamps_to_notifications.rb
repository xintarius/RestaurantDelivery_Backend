class AddTimestampsToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_timestamps :notifications
  end
end
