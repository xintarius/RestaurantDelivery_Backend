# addresses_controller
class Api::AddressesController < ApplicationController

  def get_address
    address_ids = Address.where(user_id: current_user.id).select("id, city, postal_code, street, building, apartment")

    render json: address_ids
  end
end
