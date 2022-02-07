class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_data

  def index
    @topic = Topic.find(params[:id])
    @posts = Post.where(topic_id: @topic.id, parent_id: 0, deleted_at: nil).order(:id)
    @post = Post.new
  end

  def show
  end

  def edit
    authorize @post
    @topic_id = @post.topic_id
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @topic = Topic.find(@post.topic_id)

    unless @topic.is_blocked
      respond_to do |format|
        if @post.save
          @topic.update(last_poster: @post.user_id, last_post_at: @post.created_at)
          
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post_form", partial: 'posts/form2', locals: {post: Post.new, topic_id: @topic.id}) }
        else
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post_form", partial: 'posts/form2', locals: {post: Post.new, topic_id: @topic.id}) }
        end
      end
    else
      redirect_to request.referer, alert: 'This topic is blocked!'
    end
  end

  def update
    authorize @post

    respond_to do |format|
      if @post.update(post_params)
        redirect_to @post
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post_form", partial: 'posts/form1', locals: {post: @post}) }
      end
    end
  end

  def destroy
    authorize @post

    # @post.destroy
    @post.mark_for_delete

    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.remove(@post)}
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
    end
  end

  def like
    @post = Post.find(params[:post_id])
    user_id = current_user.id
    counter = @post.like_count

    if @post.likes.exists?(user_id: user_id)
      Like.destroy(@post.likes.where(user_id: user_id).first.id)
      counter -= 1
    else 
      @post.likes.new(user_id: user_id)
      counter += 1
    end

    @post.update(like_count: counter)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :topic_id, :user_id, :parent_id)
    end
end
