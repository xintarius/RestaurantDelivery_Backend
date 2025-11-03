class Api::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  wrap_parameters false
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

  def vendor_register
    ActiveRecord::Base.transaction do
      user = User.create!(user_params.merge(role_id: 3))
      address = Address.create!(address_params)
      vendor = Vendor.create!(vendor_params.merge(user_id: user.id, address_id: address.id))
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

      render json: {
        message: "Vendor zarejestrowany i zalogowany",
        user: user.as_json(only: [:email, :username, :phone_number, :role_id]),
        vendor: vendor.as_json(only: [:name, :nip]),
        token: token
      }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username, :phone_number])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :phone_number)
  end

  def vendor_params
    params.require(:vendor).permit(:name, :nip)
  end


  def address_params
    params.require(:address).permit(:city, :postal_city, :postal_code, :street, :building, :apartment, :location_id)
  end
end
