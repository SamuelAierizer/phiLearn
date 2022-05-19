# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    @school = School.find(params[:user][:school])
    session[:school] = @school
    params[:user].delete(:school)

    user = User.find_by_email_and_school_id(params[:user][:email], @school.id)
    sign_out(current_user)

    unless user.blank?
      if user.try(:valid_password?, params[:user][:password])
        sign_in(user)
        redirect_to after_sign_in_path_for(user) and return
      end
    end

    flash[:error] = "Wrong credentials"
    redirect_to request.referer and return
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :school])
  end
end
