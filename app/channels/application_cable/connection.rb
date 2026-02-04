module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]

      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base))[0]
        if (user = User.find(decoded_token["sub"]))
          user
        else
          reject_unauthorized_connection
        end
      rescue
        reject_unauthorized_connection
      end
    end
  end
end
