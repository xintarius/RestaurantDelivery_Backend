# class courier
class Courier < ApplicationRecord
  has_many :courier_orders
  has_many :orders, through: :courier_orders
  has_many :courier_payments
  self.table_name = "couriers"
end
