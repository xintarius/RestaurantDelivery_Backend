module Api
  module Users
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token, only: [:create]

      def create
        user = User.find_for_database_authentication(email: params[:user][:email])

        if user&.valid_password?(params[:user][:password])
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

          response.set_header('Authorization', "Bearer #{token}")
          render json: {
            message: "User logged in successfully.",
            user: user,
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid login" }, status: :unauthorized
        end
      end

      private

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end