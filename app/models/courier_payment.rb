# courier_payments
class CourierPayment < ApplicationRecord
  belongs_to :courier

  self.table_name = "courier_payments"
end
