class GroupPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group_post, only: %i[ show edit update destroy ]

  def index
  end

  def show
    if @group_post.post?
      render partial: 'group_posts/group_post', locals: {group_post: @group_post}
    else 
      render partial: 'group_posts/group_announcement', locals: {group_announcement: @group_post}
    end
  end

  def edit
    authorize @group_post
  end

  def create
    @group_post = GroupPost.new(group_post_params)

    @group_post.user_id = current_user.id
    @group_post.like_count = 0

    respond_to do |format|
      @group_post.save!
      if @group_post.post?
        format.turbo_stream { render turbo_stream: turbo_stream.replace("group_post_form", partial: 'group_posts/post_form', locals: {group_id: @group_post.group_id, group_post: GroupPost.new}) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("group_announcement_form", partial: 'group_posts/announcement_form', locals: {group_id: @group_post.group_id, group_announcement: GroupPost.new}) }
      end
      helpers.notifyGroupMembersOnPost(@group_post)
    end
  end

  def update
    authorize @group_post
    @group_post.update(group_post_params)
    
    redirect_to @group_post
  end

  def destroy
    authorize @group_post
    @group_post.update(deleted_at: Time.current)

    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.remove(@group_post)}
      format.html { redirect_to request.referer, notice: "Post was successfully destroyed." }
    end
  end

  def like
    @group_post = GroupPost.find(params[:group_post_id])
    user_id = current_user.id
    counter = @group_post.like_count

    if @group_post.likes.exists?(user_id: user_id)
      Like.destroy(@group_post.likes.where(user_id: user_id).first.id)
      counter -= 1
    else 
      @group_post.likes.new(user_id: user_id)
      counter += 1
      helpers.notifyUser(@group_post.user_id, "#{current_user.username} liked your post in #{@group_post.group.name}")
    end

    @group_post.update(like_count: counter)

    # redirect_to @group_post
  end

  private
    def set_group_post
      @group_post = GroupPost.find(params[:id])
    end

    def group_post_params
      params.require(:group_post).permit(:body, :group_id, :user_id, :post_type, :like_count)
    end
end
