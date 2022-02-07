class ForumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def show
    session[:user_id] = current_user.id
    @forum = Forum.find(params[:id])

    @bookmarked = @forum.topics.where(deleted_at: nil).where(id: Like.where(user_id: current_user.id, likeable_type: 2).pluck(:likeable_id)).order(:created_at)
    @topics = @forum.topics.where(deleted_at: nil).where.not(id: Like.where(user_id: current_user.id, likeable_type: 2).pluck(:likeable_id)).order(:created_at)
  end

  def get_for_school
    @school = School.find(params[:id])
    @forum = @school.forum

    if @forum.deleted_at.nil?
      render partial: 'forums/forum', locals: {forum: @forum}
    else 
      render partial: 'forums/noforum'
    end
  end

  def school_toggle
    authorize Forum
    @school = School.find(params[:id])
    value = @school.school_forum ^ !!1
    @school.update(school_forum: value)
    session[:school] = @school
    
    if value == true
      if @school.forum.present?
        @school.forum.recover
      else 
        @forum = @school.build_forum
        @forum.save
      end
    else
      @school.forum.mark_for_delete
    end

  end

  def courses_toggle
    authorize Forum
    @school = School.find(params[:id])
    value = @school.course_forum ^ !!1
    @school.update(course_forum: value)
    session[:school] = @school

    if value == true
      Forum.where(forumable_id: Course.where(owner_id: User.where(school_id: @school.id).pluck(:id)).pluck(:id)).update_all(deleted_at: nil)
    else
      Forum.where(forumable_id: Course.where(owner_id: User.where(school_id: @school.id).pluck(:id)).pluck(:id)).update_all(deleted_at: Time.current)
    end
  end

end
