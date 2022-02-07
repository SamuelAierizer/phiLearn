class LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :not_student
  before_action :set_lecture, only: %i[ show edit update destroy ]
  before_action :set_data
  def index
    authorize Lecture
    @course = Course.find(params[:course_id])
    @lectures = @course.lectures.where(deleted_at: nil)
  end

  def show
    authorize @lecture
    @assets = Resource.get_for(@lecture.class.name, @lecture.id)
    @target = @lecture
  end

  def new
    @lecture = Lecture.new
    authorize @lecture

    @course = Course.find(params[:course_id])
  end

  def edit
    authorize @lecture
    @course = @lecture.course
  end

  def create
    @lecture = Lecture.new(lecture_params)
    authorize @lecture

    if @lecture.save
      redirect_to @lecture, notice: "Lecture was successfully created."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def update
    authorize @lecture

    if @lecture.update(lecture_params)
      redirect_to @lecture, notice: "Lecture was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @lecture

    # @lecture.destroy
    @lecture.update(deleted_at: Time.now)

    flash[:info] = "Lecture was successfully destroyed."
    redirect_to lectures_path(course_id: @lecture.course_id), status: 303
  end

  def mass_delete
    authorize Lecture

    # Lecture.destroy(params[:lecture_ids])
    Lecture.where(id: params[:lecture_ids], deleted_at: nil).update_all(deleted_at: Time.now)

    flash[:info] = "Lectures were successfully destroyed."
    redirect_to schools_path, status: 303
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lecture_params
      params.require(:lecture).permit(:name, :description, :course_id)
    end
end
