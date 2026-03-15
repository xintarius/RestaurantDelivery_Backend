# role model
class Role < ApplicationRecord
  has_many :users
  has_many :notification_roles
  has_many :notifications, through: :notification_roles
end
