module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]

      secret = ENV["DEVISE_JWT_SECRET_KEY"]

      begin
        decoded = JWT.decode(token, secret, true, { algorithm: "HS256" })[0]

        if (user = User.find_by(id: decoded["sub"]))
          user
        else
          reject_unauthorized_connection
        end
      rescue JWT::DecodeError => e
        STDOUT.puts "DEBUG: Błąd dekodowania JWT: #{e.message}"
        reject_unauthorized_connection
      rescue => e
        STDOUT.puts "DEBUG: Inny błąd Action Cable: #{e.message}"
        reject_unauthorized_connection
      end
    end
  end
end

