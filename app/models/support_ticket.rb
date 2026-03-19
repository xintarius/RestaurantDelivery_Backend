# support tickets
class SupportTicket < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  belongs_to :courier
end