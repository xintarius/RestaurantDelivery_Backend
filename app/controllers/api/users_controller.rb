# users controller
module Api
    class UsersController < ApplicationController
      def profile
        render json: {
          id: current_user.id,
          email: current_user.email,
          name: current_user.role&.name,
          code: current_user.role&.code
        }
      end
    end
end
