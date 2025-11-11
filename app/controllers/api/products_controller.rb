# products controller
class Api::ProductsController < ApplicationController
  # before_action :authenticate_user!

  def get_products
    vendor = Vendor.where(user_id: current_user)
    products = Product.select(:id, :product_name, :file_path, :description, :price_gross)
    puts products.inspect
    render json: products.as_json
  end

  def create_product
    user = current_user.id
    vendor = Vendor.find_by(user_id: user)
    products = vendor.products.new(strong_params)
    if products.save
      render json: products, status: 200
    else
      render json: { errors: products.errors }, status: :unprocessable_entity
    end
  end

  def strong_params
    params.require(:product).permit(:product_name, :description, :price_gross, :price_net)
  end
end
