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
      data: vendors_paginated.as_json(only: [ :id, :name, :file_path, :description ]),
      meta: {
        current_page: page,
        per_page: per_page,
        total_records: vendors_scope.count,
        total_pages: (vendors_scope.count / per_page.to_f).ceil
      }
    }
  end

  def update_status
    vendor = current_vendor
    if vendor.update(is_active: params[:is_active])
      render json: {
        message: "Status widoczności zaktualizowany",
        isActive: vendor.is_active
      }
    else
      render json: { error: "Nie udało się zmienić  statusu" }, status: :unprocessable_entity
    end
  end

  def show_availability
    return [] unless data
    vendor = current_vendor
    render json: {
      isActive: vendor.is_active,
      standardHours: { open: vendor.std_open, close: vendor.std_close },
      exceptions: vendor.vendor_exceptions.map { |e|
        { id: e.id, date: e.special_date, type: e.exception_type, open: e.open_time, close: e.close_time }
      }
    } || []
  end

  def update_standard_hours
    vendor = current_vendor
    if vendor.update(std_open: params[:open], std_close: params[:close])
      render json: { message: "Godziny standardowe zapisane" }
    else
      render json: { error: "Błąd zapisu" }, status: :unprocessable_entity
    end
  end

  def sync_exceptions
    vendor = current_vendor
    ActiveRecord::Base.transaction do
    vendor.vendor_exceptions.destroy_all
    if params[:exceptions].present?
      params[:exceptions].each do |ex|
      vendor.vendor_exceptions.create!(
        special_date: ex[:date],
        exception_type: ex[:type],
        open_time: ex[:open],
        close_time: ex[:close]
      )
      end
    end
    end
    render json: { message: "Wyjątki zsynchronizowane" }
  end
end
