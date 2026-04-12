# products controller
class Api::ProductsController < ApplicationController
  # before_action :authenticate_user!

  def get_products
    vendor = Vendor.where(user_id: current_user)
    products = Product.where(vendor_id: vendor).where.not(availability_status: 'ARCHIVED').select(:id, :product_name, :file_path, :description, :price_gross, :availability_status)
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

  def update_product
    product = Product.find(params[:id])

    if product.update(strong_params)
      render json: { message: 'Produkt został pomyślnie zaktualizowany', product: product }, status: :ok
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Nie znaleziono produktu' }, status: :not_found
  end

  def delete_product
    product = Product.find(params[:id])
    product.update(availability_status: 'ARCHIVED')

    render json: { message: 'Produkt został usunięty' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Nie znaleziono produktu' }, status: :not_found
  end

  private

  def strong_params
    params.require(:product).permit(:product_name, :description, :price_gross, :price_net, :availability_status)
  end
end
