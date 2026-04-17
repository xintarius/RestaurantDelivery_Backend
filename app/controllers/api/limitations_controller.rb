# limitations controller
class Api::LimitationsController < Api::ApplicationController
  def index
    paused_time = current_vendor.paused_until
    display_pause = (paused_time && paused_time > Time.current) ? paused_time : nil

    render json: {
      paused_until: display_pause,
      max_active_orders: current_vendor.max_active_orders
    }
  end

  def set_limit
    case params[:type]
    when "time"
      minutes = params[:value].to_i

      if current_vendor.update(paused_until: Time.current + minutes.minutes, max_active_orders: nil)
        render json: { message: "Pauza czasowa ustawiona", paused_until: current_vendor.paused_until }, status: :ok
      else
        render json: { error: "Błąd zapisu" }, status: :unprocessable_entity
      end

    when "quantity"
      limit = params[:value].to_i

      if current_vendor.update(max_active_orders: limit, paused_until: nil)
        render json: { message: "Limit ilościowy ustawiony", max_active_orders: current_vendor.max_active_orders }, status: :ok
      else
        render json: { error: "Nieznany typ limitu" }, status: :bad_request
      end
    end
  end
end