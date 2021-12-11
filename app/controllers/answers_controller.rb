class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[ show edit update destroy ]
  before_action :set_school
  before_action :set_courses

  # GET /answers or /answers.json
  def index
    authorize Answer
    @answers = Answer.all
  end

  # GET /answers/1 or /answers/1.json
  def show
    authorize @answer
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
    authorize @answer
  end

  # POST /answers or /answers.json
  def create
    @answer = Answer.new(answer_params)

    respond_to do |format|
     if @answer.save
       @answer.compute_mark
       format.html { redirect_to @answer, notice: "Answer was successfully created." }
       format.json { render :show, status: :created, location: @answer }
     else
       format.html { render :new, status: :unprocessable_entity }
       format.json { render json: @answer.errors, status: :unprocessable_entity }
     end
    end
  end

  # PATCH/PUT /answers/1 or /answers/1.json
  def update
    authorize @answer

    @answer.answers_type = params[:answers_type]
    respond_to do |format|
      if @answer.update(answer_params)
        @answer.compute_mark
        @answer.solution.update_grade
        format.html { redirect_to @answer, notice: "Answer was successfully updated." }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1 or /answers/1.json
  def destroy
    authorize @answer

    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url, notice: "Answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:answer_given, :answers_type, :mark_achieved, :solution_id, :question_id)
    end

end
