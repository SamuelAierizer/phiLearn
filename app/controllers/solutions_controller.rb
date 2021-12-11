class SolutionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_solution, only: %i[ show edit update destroy ]
  before_action :set_school
  before_action :set_courses

  def index
    authorize Solution
    @assignment = Assignment.find(params[:id])
    @solutions = Solution.where(assignment_id: @assignment.id)
  end

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

  def edit
    authorize @solution
    
    @assignment = @solution.assignment
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
        format.html { redirect_to @solution.assignment, notice: "Solution was successfully created." }
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @solution

    respond_to do |format|
      if @solution.update(solution_params)
        format.html { redirect_to @solution.assignment, notice: "Solution was successfully updated." }
        format.json { render :show, status: :ok, location: @solution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @solution
    @course = @solution.assignment.course

    # @solution.destroy
    @solution.update(deleted_at: Time.current)

    flash[:info] = "Solution was successfully destroyed."
    redirect_to @course, status: 303
  end

  def mass_delete
    authorize Solution

    # Solution.destroy(params[:solution_ids])
    Solution.where(id: params[:solution_ids], deleted_at: nil).update_all(deleted_at: Time.current)

    flash[:info] = "Solutions deleted successfully."
    redirect_to schools_path, status: 303
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
