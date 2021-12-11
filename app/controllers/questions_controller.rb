class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[ show edit update destroy ]
  before_action :set_school
  before_action :set_courses

  # GET /questions or /questions.json
  def index
    authorize Question
    policies = policy_scope(Question)
  end

  # GET /questions/1 or /questions/1.json
  def show
    authorize @question

    @solution = Solution.new
  end

  # GET /questions/new
  def new
    @question = Question.new
    authorize @question
    @assignment = Assignment.find(params[:assignment_id])
  end

  # GET /questions/1/edit
  def edit
    authorize @question

    @assignment = Assignment.find(params[:assignment_id])
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)

    authorize @question

    @question.question_type = params[:question_type]

    unless @question.open?
      @question.answer = get_answer(params[:question][:question_options_attributes])
    end

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question.assignment, notice: "Question was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    authorize @question

    unless @question.open?
      params[:question][:answer] = get_answer(params[:question][:question_options_attributes])
    end

    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question.assignment, notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    authorize @question

    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:question_asked, :answer, :question_type, :mark_available, :assignment_id, question_options_attributes: [:_destroy, :id, :value, :correct])
    end

    def get_answer(options)
      answer = ""
      
      options.each do |key, option|
        if option[:correct] == "1"
          answer += option[:value] + " "
        end
      end

      return answer.chomp(" ")
    end
end
