# roles controller
class Api::RolesController < ApplicationController
  before_action :authenticate_user!
  def roles_index
    roles = Role.all
    render json: roles
  end

  def create
    role = Role.new(role_params)
    if role.save
      render json: role, status: :created
    else
      render json: { errors: role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def role_params
    params.require(:role).permit(:name, :code, :description )
  end
end
