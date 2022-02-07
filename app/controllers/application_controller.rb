class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from StandardError, with: :render_500

  def render_404
    render "home/404"
  end

  def render_500(e)
    render "home/500"
  end

  def after_sign_in_path_for(resource)
    schools_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    
    redirect_to schools_path and return if user_signed_in?

    redirect_to root_path and return
  end

  def not_student
    if current_user.student?
      flash[:error] = "You have no access for this resource"
      redirect_to schools_path
    end
  end

  def set_data
    @school = School.new(session[:school])
    if current_user.teacher?
      @courses = current_user.myCourses.where(deleted_at: nil).order(:id)
      @studies = current_user.courses.where(deleted_at: nil).order(:id)
    elsif current_user.student?
      @courses = current_user.courses.where(deleted_at: nil).order(:id)
    else
      @courses = Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id), deleted_at: nil).order(:name).all()
    end
  end

end
