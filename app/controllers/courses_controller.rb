class CoursesController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :my_set, only: %i[ grades deadlines add_users new_users stats ]
  before_action :set_school
  before_action :set_courses

  def index
    authorize Course
    @coursesForTable = policy_scope(Course).where(deleted_at: nil).order(:name).paginate(page: params[:page])
  end

  def stats
    authorize Course
    @assignments = @course.assignments.order(:name).paginate(page: params[:page])
    @total = @course.users.count
  end

  def show
    authorize @course
    @lectures = @course.lectures.where(deleted_at: nil)
    @assignments = @course.assignments.where(deleted_at: nil)
    @assets = Resource.get_for(@course.class.name, @course.id)
    @target = @course
  end

  def grades
    @solutions = []
    if current_user.student?
      @solutions = Solution.where(user_id: current_user.id, course_id: @course.id, deleted_at: nil).order(:assignment_id)
    else 
      @solutions = Solution.where(course_id: @course.id, deleted_at: nil).order(:assignment_id)
    end
  end

  def deadlines
    @time = Time.current
    @assignments = @course.assignments.where(deleted_at: nil)
  end

  def new
    @course = Course.new
    authorize @course
  end

  def edit
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    authorize @course

    @course.owner_id = current_user.id

    if @course.save
      if @school.course_forum and !@course.forum.present?
        @forum = @course.build_forum
        @forum.save
      end

      redirect_to @course, notice: "Course was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @course

    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @course

    # @course.destroy
    @course.mark_for_delete

    flash[:info] = "Course was successfully destroyed."
    redirect_to courses_url, status: 303
  end

  def mass_delete
    authorize Course

    # Course.destroy(params[:course_ids])
    Course.where(id: params[:course_ids], deleted_at: nil).update_all(deleted_at: Time.current)

    flash[:info] = "Courses were successfully destroyed."
    redirect_to courses_path, status: 303
  end

  def add_users
    authorize @course

    @students = User.where(id: Student.where(course_id: @course.id).pluck(:user_id).uniq).order(:id)
                  .paginate(page: params[:page], per_page: 10)
    
  end

  def new_users
    if params[:searched].present?
      @users = User.where("username LIKE :username", username: "%#{params[:searched]}%")
                .where.not(id: Student.where(course_id: @course.id).pluck(:user_id).uniq)
                .where(school_id: current_user.school_id, role: 2).order(:id)
                .paginate(page: params[:page], per_page: 5)
    
    else 
      @users = User.where.not(id: Student.where(course_id: @course.id).pluck(:user_id).uniq)
                .where(school_id: current_user.school_id, role: 2).order(:id)
                .paginate(page: params[:page], per_page: 5)
    end
   
    render layout: false
  end

  def toggle_user
    @course = Course.find(params[:course_id])
    user_id = params[:user_id].to_i
    
    if @course.user_ids.include? user_id
      @course.users.delete(User.find(user_id))
    else 
      @course.users << User.find(user_id)
    end

  end

  def populate
    @course = Course.find(params[:course_id])
    authorize @course

    new_ids = []
    remove_ids = []

    new_ids = params[:user_ids].split(",").map(&:to_i) unless params[:user_ids].blank?
    remove_ids = params[:remove_ids].map(&:to_i) unless params[:remove_ids].blank?

    unless @course.user_ids.empty?
      old_ids = @course.user_ids.map(&:to_i)
      old_ids -= remove_ids
      new_ids += old_ids
    end

    @course.user_ids = new_ids
   
    redirect_to course_add_users_path
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def my_set
      @course = Course.find(params[:course_id])
    end

    def course_params
      params.require(:course).permit(:name, :description, :image_path, :owner_id, :user_ids)
    end
end
