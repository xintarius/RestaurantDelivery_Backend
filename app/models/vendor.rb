# vendor model
class Vendor < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :category_type
  has_many :products
  has_many :orders
  has_many :cart_summaries
  has_many :support_tickets
  has_many :vendor_exceptions

  self.table_name = "vendors"

  def current_vendor_status
    return :deactivated unless is_active

    today = Date.today
    exception = vendor_exceptions.find_by(special_date: today)

    if exception
      return :closed if exception.exception_type === "closed"
      return check_time(exception.open_time, exception.close_time)
    end

    check_time(std_open, std_close)
  end
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

  private

  def check_time(open_s, close_s)
    current_time = Time.now.strftime("%H:%M")
    (current_time >= open_s && current_time <= close_s) ? :open : :closed
  end
end
