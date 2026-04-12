# vendor controller
class Api::VendorsController < Api::ApplicationController
  before_action :authenticate_user!
  def vendors
    per_page = params.fetch(:per_page, 12).to_i
    page = params.fetch(:page, 1).to_i

    vendors_scope = Vendor.all
    if params[:category_type_id].present?
    vendors_scope = Vendor.where(category_type_id: params[:category_type_id])
    end

    vendors_paginated = vendors_scope.limit(per_page).offset((page - 1) * per_page)
    render json: {
      data: vendors_paginated.as_json(only: [:id, :name, :file_path, :description]),
      meta: {
        current_page: page,
        per_page: per_page,
        total_records: vendors_scope.count,
        total_pages: (vendors_scope.count / per_page.to_f).ceil
      }
    }
  end
end
