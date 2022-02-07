class Student::SolutionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_solution, only: %i[ show ]
  before_action :set_data


  def show
    authorize @solution
    @assignment = @solution.assignment
  end

  def new
    @solution = Solution.new
    @assignment = Assignment.find(params[:id])
    @questions = Question.where(assignment_id: @assignment.id)
    @solution.answers.build
  end


  def create
    @solution = Solution.new(solution_params)
    @solution.grade = 1.0
    @solution.course_id = @solution.assignment.course_id

    respond_to do |format|
      if @solution.save
        if @solution.assignment.quizz?
          @solution.calculate_grade
        end
        format.html { redirect_to student_assignment_path(@solution.assignment), notice: "Solution was successfully created." }
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_solution
      @solution = Solution.find(params[:id])
    end

    def solution_params
      params.require(:solution).permit(:grade, :file, :user_id, :assignment_id, 
        :answers_attributes => {})
    end
end
