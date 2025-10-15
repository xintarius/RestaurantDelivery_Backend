# products controller
class Api::ProductsController < ApplicationController
  before_action :authenticate_user!

  def create_product
    product = Vendor.product.new(product_params)
    if product.save
      render json: product, status: 200
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  def product_params
    params.require(:product).permit(:product_name, :description, :price_gross, :price_net)
  end
end
