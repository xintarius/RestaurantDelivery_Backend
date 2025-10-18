# billing controller
module Api
class V1::BillingController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  before_action :authenticate_api_key!
  def earnings
    courier_payments = CourierPayment.where(courier_id: params[:id]).joins(:courier).select("couriers.id as id, courier_payments.courier_id,
                                    courier_payments.gross_payment, courier_payments.net_payment,
                                    courier_payments.vat")

    render json: courier_payments
  end

  def authenticate_api_key!
    key = request.headers["Authorization"]&.split("Bearer ")&.last
    unless key && ActiveSupport::SecurityUtils.secure_compare(key, ENV["BILLING_API_KEY"])
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
end
