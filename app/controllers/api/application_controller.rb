class Api::ApplicationController < ActionController::API
  before_action :authenticate_user_from_token!
  rescue_from JWT::ExpiredSignature, with: :handle_expired_token
  rescue_from JWT::DecodeError, with: :handle_invalid_token

  private

  def authenticate_user_from_token!
    auth_header = request.headers["Authorization"]
    token = auth_header&.split(" ")&.last
    return render json: { error: "Unauthorized" }, status: :unauthorized unless token

    payload = JWT.decode(token, ENV["DEVISE_JWT_SECRET_KEY"], true, algorithm: "HS256")[0]
    @current_user = User.find_by(id: payload["sub"])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def handle_expired_token
    render json: { error: "Token has expired" }, status: :unauthorized
  end

  def handle_invalid_token
    render json: { error: "Invalid token" }, status: :unauthorized
  end

end
