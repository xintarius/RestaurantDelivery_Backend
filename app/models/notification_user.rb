# notification_user model
class NotificationUser < ApplicationRecord
  belongs_to :notification
  belongs_to :user
end