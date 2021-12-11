class SchoolsController < ApplicationController
  before_action :authenticate_user!, except: %i[ create new ]
  before_action :set_school
  before_action :set_courses, only: %i[ index overview stats ]

  def index
    policies = policy_scope(School)
    if current_user.student?
      @myCourses = current_user.courses.where(deleted_at: nil).order(:name)
    elsif current_user.teacher?
      @myCourses = current_user.myCourses.where(deleted_at: nil).order(:name)
    else
      @myCourses = Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id), deleted_at: nil).order(:name).all()
    end
  end

  def overview
    authorize @school
    if params[:role].blank?
      @users = User.where(school_id: @school.id, deleted_at: nil).order(:id).paginate(page: params[:page], per_page: 10)
    else
      @users = User.where(school_id: @school.id, role: params[:role], deleted_at: nil).order(:id).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    redirect_to action: "index"
  end

  def new
    @school = School.new
  end

  def edit
    authorize @school
  end

  def create
    params[:school] = params[:user][:school_attributes]
    params[:user].delete(:school_attributes)
    
    @schools = School.new(params.require(:school).permit(:name, :subdomain))
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :username, :role, :profile_picture, :school_id))
      
    if @schools.save!
      @user.role = 0
      @user.school_id = @schools.id

      if @user.save!
        sign_in(@user)
      else  
        @school.destroy!
      end
    else
      redirect_to new_schools_path, alert: 'Failed to enroll new school'
      return
    end

    session[:school] = @school
    redirect_to schools_path, notice: 'Welcome to phi learn'
  end

  def update
    authorize @school
    if @school.update(school_params)
      redirect_to @school, notice: "School was updated successfully."
    else 
      render :edit
    end
  end

  def destroy
    authorize @school
    School.find(params[:id]).destroy
    redirect_to :new
  end

  private
    def set_school
      @school = School.new(session[:school])
    end

    def school_params
      params.require(:schools).permit( :name, :subdomain )
    end
end
