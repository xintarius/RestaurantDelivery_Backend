# class courier
class Courier < ApplicationRecord
  has_many :courier_orders
  has_many :orders, through: :courier_orders
end