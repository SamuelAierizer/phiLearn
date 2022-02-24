class Student::CoursesController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :set_course, only: %i[ show ]
  before_action :my_set, only: %i[ grades deadlines ]
  before_action :set_data

  def show
    authorize @course
    @lectures = @course.lectures.where(deleted_at: nil)
    @assignments = @course.assignments.where(deleted_at: nil)
    @target = @course

    unless @course.forum
      @forum = @course.build_forum
      @forum.save
    end
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


  private
    def set_course
      @course = Course.find(params[:id])
    end

    def my_set
      @course = Course.find(params[:course_id])
    end
    
end
