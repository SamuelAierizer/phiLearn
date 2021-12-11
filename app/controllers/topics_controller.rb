class TopicsController < ApplicationController
  before_action :set_topic, only: %i[ show edit update destroy block bookmark ]
  before_action :set_school
  before_action :set_courses

  def edit
    authorize @topic
    @forum_id = @topic.forum_id
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.owner_id = current_user.id

    authorize @topic
    respond_to do |format|
      if @topic.save
        format.html { redirect_to forum_path(id: @topic.forum), notice: "Topic was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@topic, partial: 'topics/form2', locals: {topic: @topic, forum_id: @topic.forum_id}) }
      end
    end
  end

  def update
    authorize @topic

    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: "Topic was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@topic, partial: 'topics/form1', locals: {topic: @topic}) }
      end
    end
  end

  def block
    authorize @topic

    new_value = true
    if @topic.is_blocked then new_value = false end
      
    @topic.update(is_blocked: new_value)
  end

  def bookmark
    user_id = current_user.id

    if @topic.likes.exists?(user_id: user_id)
      Like.destroy(@topic.likes.where(user_id: user_id).first.id)
    else 
      @topic.likes.new(user_id: user_id)
    end

    if @topic.save then redirect_to request.referer end
  end

  def destroy
    authorize @topic
    # @topic.destroy
    @topic.mark_for_delete
    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.remove(@topic)}
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:name, :description, :last_poster, :last_post_at, :forum_id, :owner_id, :is_blocked)
    end
end
