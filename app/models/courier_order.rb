# class courier_order
class CourierOrder < ApplicationRecord
  belongs_to :courier
  belongs_to :order
end
