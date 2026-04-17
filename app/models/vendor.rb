# vendor model
class Vendor < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :category_type
  has_many :products
  has_many :orders
  has_many :cart_summaries
  has_many :support_tickets

  self.table_name = "vendors"

  def vendor_paused?
    paused_until.present? && paused_until > Time.current
  end

  def quantity_limit_reached?
    return false if max_active_orders.nil?

    active_orders_count = orders.where(status: %w[pending preparing]).count
    active_orders_count >= max_active_orders
  end

  def accepting_orders?
    !vendor_paused? && !quantity_limit_reached?
  end
end
