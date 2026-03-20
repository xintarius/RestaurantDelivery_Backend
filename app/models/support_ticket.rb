# support tickets
class SupportTicket < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vendor, optional: true
  belongs_to :courier, optional: true
end
