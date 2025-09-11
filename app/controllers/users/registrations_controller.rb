class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: "User registered successfully." }, status: :ok
    else
      if resource.errors.details[:email]&.any? { |e| e[:error] == :taken }
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      else
        render json: {errors: resource.errors.full_messages }, status: :internal_server_error
      end
    end
  end
end
