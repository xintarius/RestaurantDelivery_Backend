class Api::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    build_resource(sign_up_params)

    if resource.save
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)

      render json: {
        message: "User registered and logged in successfully.",
        user: resource.as_json(only: [:id, :email, :username, :phone_number, :role_id]),
        token: token
      }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_content
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :phone_number])
  end
end
