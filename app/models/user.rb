class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  belongs_to :role
  has_many :vendors
  has_many :orders
  has_many :cart_summaries
  has_many :notification_users
  has_many :notifications, through: :notification_users
  has_one :address, dependent: :destroy
  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= Role.find_by(code: "CLT")
  end
end
