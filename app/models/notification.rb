# notifiaction model
class Notification < ApplicationRecord
  has_many :notification_users
  has_many :users, through: :notification_users
end
