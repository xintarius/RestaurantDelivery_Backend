# history order
class HistoryOrder < ApplicationRecord
  belongs_to :order
  belongs_to :courier
  belongs_to :vendor
end