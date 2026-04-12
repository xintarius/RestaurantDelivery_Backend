# vendor statistics service
class VendorStatisticsService
  def initialize(vendors_data, timeframe)
    @vendor = vendors_data
    set_timeframes(timeframe)
  end

  def generate_kpis
    current_all = @vendor.orders.where(created_at: @current_period)
    previous_all = @vendor.orders.where(created_at: @previous_period)

    current_paid = current_all.where(payment_status: "paid")
    previous_paid = previous_all.where(payment_status: "paid")

    rev_curr = current_paid.joins(:order_products).sum("order_products.total_price").to_f
    ord_curr = current_paid.count
    aov_curr = ord_curr.positive? ? rev_curr / ord_curr : 0

    payout_curr = rev_curr * 0.88

    prep_curr = calculate_avg_prep_time(current_paid)
    rej_curr = calculate_rejection_rate(current_all)

    rev_prev = previous_paid.joins(:order_products).sum('order_products.total_price').to_f
    ord_prev = previous_paid.count
    aov_prev = ord_prev.positive? ? rev_prev / ord_prev : 0
    payout_prev = rev_prev * 0.88
    prep_prev = calculate_avg_prep_time(previous_paid)
    rej_prev = calculate_rejection_rate(previous_all)

    {
      revenue: { value: rev_curr.round(2), trend: calc_trend(rev_curr, rev_prev) },
      orders: { value: ord_curr, trend: calc_trend(ord_curr, ord_prev) },
      aov: { value: aov_curr.round(2), trend: calc_trend(aov_curr, aov_prev) },
      payout: { value: payout_curr.round(2), trend: calc_trend(payout_curr, payout_prev) },
      prep_time: { value: prep_curr, trend: calc_trend(prep_curr, prep_prev) },
      rejections: { value: rej_curr, trend: calc_trend(rej_curr, rej_prev) }
    }
  end

  private

  def set_timeframes(timeframe)
    now = Time.current
    case timeframe
    when '7days'
      @current_period = (now - 7.days)..now
      @previous_period = (now - 14.days)..(now - 7.days)
    when '30days'
      @current_period = (now - 30.days)..(now)
      @previous_period = (now - 60.days)..(now - 30.days)
    else
      @current_period = now.beginning_of_day..now.end_of_day
      @previous_period = (now - 1.day).beginning_of_day..(now - 1.day).end_of_day
    end
  end

  def calculate_rejection_rate(orders_scope)
    total = orders_scope.count
    return 0.0 if total.zero?

    rejected = orders_scope.where(order_status: ['rejected', 'cancelled']).count
    ((rejected.to_f / total) * 100).round(1)
  end

  def calculate_avg_prep_time(orders_scope)
    valid_orders = orders_scope.where.not(estimated_delivery_time: nil)

    return 0 if valid_orders.empty?

    avg_seconds = valid_orders.average("EXTRACT(EPOCH FROM (estimated_delivery_time - created_at))")
    avg_seconds ? (avg_seconds / 60.0).round(0) : 0
  end

  def calc_trend(current, previous)
    return 0.0 if current.zero? && previous.zero?
    return 100.0 if previous.zero? && current.positive?
    return -100.0 if current.zero? && previous.positive?

    (((current - previous) / previous.to_f) * 100).round(1)
  end
end