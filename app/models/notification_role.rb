# notification_role
class NotificationRole < ApplicationRecord
  belongs_to :notification
  belongs_to :role
end