# notifications controller
class Api::NotificationsController < ApplicationController

  def get_notification
    notifications = Notification.joins(:roles)
                                .where(roles: { id: current_user.role_id })
                                .order(created_at: :desc)
    render json: notifications
  end
end