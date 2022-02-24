class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data, only: %i[index]

  def index
    @notifications = Notification.where(user_id: current_user.id).order(id: :desc)
  end

  def display
    @notifications = Notification.where(user_id: current_user.id, status: 'unread').order(id: :desc)
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.save!
  end

  def read
    @notification = Notification.find(params[:id])
    @notification.update(status: 'read')
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@notification) }
    end
  end

  def mass_delete
    Notification.destroy(params[:notif_ids])

    flash[:info] = "Notifications were successfully destroyed."
    redirect_to schools_path, status: 303
  end

  private
  def notification_params
    params.require(:notification).permit(:notif_type, :message, :status, :user_id)
  end

end