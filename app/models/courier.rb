# class courier
class Courier < ApplicationRecord
  belongs_to :user
  has_many :courier_orders
  has_many :orders, through: :courier_orders
  has_many :courier_payments
  has_many :support_tickets
  has_many :wallet_transactions
  self.table_name = "couriers"
end
