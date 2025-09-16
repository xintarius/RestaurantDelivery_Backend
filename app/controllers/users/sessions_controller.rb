class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: "User logged successfully.", user: resource }, status: :ok
    else
      render json: { error: resource.errors.full_messages }, status: :unauthorized
    end
  end
end
