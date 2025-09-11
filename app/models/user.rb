class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  devise :database_authenticatable, :registerable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
