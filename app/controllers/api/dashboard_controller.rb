module Api
  class DashboardController <  ApplicationController
  before_action :authenticate_user!

  def dashboard
    render json: { email: @current_user.email, image_url: "/kebab.jpeg" }
  end
  end
end
