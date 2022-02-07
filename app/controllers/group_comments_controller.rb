class GroupCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ show edit update destroy ]

  def show
    if @comment.parent_id.nil?
      render partial: 'group_comments/comment', locals: {comment: @comment}
    else
      render partial: 'group_comments/reply', locals: {reply: @comment}
    end
  end

  def new
  end

  def edit
    if @comment.parent_id.nil?
      render 'group_comments/edit'
    else
      render 'group_comments/edit_reply', reply: @comment
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @target = @comment.target

    @comment.user_id = current_user.id
    @comment.like_count = 0

    @comment.save

    redirect_to request.referer
  end

  def update
    @comment.update(comment_params)
    redirect_to request.referer
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.remove(@comment)}
      format.html { redirect_to request.referer, notice: "Post was successfully destroyed." }
    end
  end

  def like
    @comment = Comment.find(params[:comment_id])
    user_id = current_user.id
    counter = @comment.like_count

    if @comment.likes.exists?(user_id: user_id)
      Like.destroy(@comment.likes.where(user_id: user_id).first.id)
      counter -= 1
    else 
      @comment.likes.new(user_id: user_id)
      counter += 1
    end

    @comment.update(like_count: counter)

    # redirect_to @group_post
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body, :target_type, :target_id, :parent_id, :user_id)
    end

end
