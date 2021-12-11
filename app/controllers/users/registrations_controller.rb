# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ActionController::MimeResponds
  skip_before_action :require_no_authentication, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_school, only: [:new, :edit]
  before_action :set_courses, only: %i[ edit ]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :username, :role, :profile_picture, :school_id))
    
    @user.school_id = current_user.school_id
    @user.role = params[:role]

    if @user.save!
      redirect_to schools_path, notice: 'New user created.'
    else
      render :new, alert: 'Failed to create new user.'
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  def clear
    @user = User.find(params[:id])
    # @user.destroy!
    @user.update(deleted_at: Time.current)

    flash[:info] = 'User and all associated files deleted'
    redirect_to schools_overview_path, status: 303
  end

  def import
    unless params[:file].blank?
      if params[:file].original_filename.split('.').last == "csv"
        User.import_from(params[:file])
        redirect_to schools_overview_path, status: 303, notice: 'Users imported successfully.'
        return
      end
    end

    redirect_to new_user_registration_path, alert: 'Could not import from file'
  end

  def mass_delete
    # User.destroy(params[:user_ids])
    User.where(id: params[:user_ids]).update_all(deleted_at: Time.current)
    
    flash[:info] = 'Users deleted successfully'
    redirect_to schools_overview_path, status: 303
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :first_name, :last_name, :username, :role, :profile_picture, :school_id, school_attributes: [:name, :subdomain]])
  end

  def set_school
    @school = School.new(session[:school])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
end
