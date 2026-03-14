# role model
class Role < ApplicationRecord
  has_many :users
  has_many :notification_roles
end
