class AssignmentsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :not_student
  before_action :set_assignment, only: %i[ show edit update destroy ]
  before_action :set_data


  def index
    authorize Assignment
    @course = Course.find(params[:course_id])
    @assignments = @course.assignments.where(deleted_at: nil)
  end

  def show
    authorize @assignment

    @questions = Question.where(assignment_id: @assignment.id)

    @target = @assignment
  end

  def new
    @assignment = Assignment.new
    authorize @assignment

    @course = Course.find(params[:course_id])
  end

  def edit
    authorize @assignment
    @course = @assignment.course
  end

  def create
    @assignment = Assignment.new(assignment_params)

    authorize @assignment

    @assignment.assignment_type = params[:assignment_type]

    if @assignment.save
      redirect_to @assignment, notice: "Assignment was successfully created."
    else
      flash[:error] = "Assignment could not be created."
      redirect_to new_assignment_path(course_id: @assignment.course_id), status: :unprocessable_entity
    end
  end

  def update
    authorize @assignment

    @assignment.assignment_type = params[:assignment_type]
    if @assignment.update(assignment_params)
      redirect_to @assignment, notice: "Assignment was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    authorize @assignment
    @course = @assignment.course

    # @assignment.destroy
    @assignment.update(deleted_at: Time.current)

    flash[:info] = "Assignment was successfully destroyed."
    redirect_to request.referer, status: 303
  end

  def mass_delete
    authorize Assignment

    # Assignment.destroy(params[:assignment_ids])
    Assignment.where(id: params[:assignment_ids], deleted_at: nil).update_all(deleted_at: Time.current)

    flash[:info] = "Assignments deleted successfully."
    redirect_to schools_path, status: 303
  end

  def delete_files_attachment
    @assignment = Assignment.find(params[:assignment_id])
    @assignment.files.find_by_id(params[:file_id]).purge
    redirect_to @assignment, status: 303
  end

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:name, :description, :assignment_type, :deadline, :course_id, files: [])
    end
end
