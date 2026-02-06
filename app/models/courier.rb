# class courier
class Courier < ApplicationRecord
  belongs_to :user
  has_many :courier_orders
  has_many :orders, through: :courier_orders
  has_many :courier_payments
  self.table_name = "couriers"
end
