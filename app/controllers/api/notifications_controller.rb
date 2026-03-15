# notifications controller
class Api::NotificationsController < ApplicationController

  def get_notification
    notifications = Notification.joins(:roles)
                                .where(roles: { id: current_user.role_id })
                                .order('notifications.created_at DESC')
    render json: notifications
  end
end