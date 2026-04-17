# statistics controller
class Api::StatisticsController < Api::ApplicationController

  def statistics
    vendors_data = Vendor.find_by!(id: current_vendor)

    timeframe = params[:timeframe] || "today"

    stats = VendorStatisticsService.new(vendors_data, timeframe).generate_kpis

    render json: stats, status: :ok
  end
end