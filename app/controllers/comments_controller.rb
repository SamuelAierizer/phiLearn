class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ show edit update destroy ]

  def new
    @comment = Comment.new(parent_id: params[:parent_id])
    @target_type = params[:target_type]
    @target_id = params[:target_id]
  end

  def edit
    authorize @comment
  end

  def create
    @comment = Comment.new(comment_params)
    @target = @comment.target

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @target, notice: "Comment was successfully created." }
      else
        format.html { render @target, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.target, notice: "Comment was successfully updated." }
      else
        format.html { render @comment.target, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to schools_path, notice: "Comment was successfully destroyed." }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body, :target_type, :target_id, :parent_id, :user_id)
    end
end
