# users controller
class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  def profile
    render json: user_profile_data
  end

  private

  def user_profile_data
    {
      id: current_user.id,
      email: current_user.email,
      phone_number: current_user.phone_number,
      username: current_user.username,
      name: current_user.role&.name,
      code: current_user.role&.code,
      address: address_data
    }
  end

  def address_data
    address = current_user.address

    return {} unless address.present?
    {
      street: current_user.address.street,
      city: current_user.address.city,
      building: current_user.address.building,
      postal_code: current_user.address.postal_code
    }
  end
end
