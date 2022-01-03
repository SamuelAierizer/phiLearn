class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school, only: %i[index general_stats forum_panel import export trash]
  before_action :set_courses, only: %i[index general_stats forum_panel import export trash]
  
  def index
  end

  def general_stats
  end

  def forum_panel
  end

  def import
  end

  def export
  end

  def trash  
  end

  def trash_users
    @users = User.where(school_id: current_user.school_id).where.not(deleted_at: nil)
  end

  def trash_courses
    @courses = Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id)).where.not(deleted_at: nil)
  end

  def trash_lectures
    @lectures = Lecture.where(course_id: Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id)).pluck(:id)).where.not(deleted_at: nil)
  end

  def trash_assignments
    @assignments = Assignment.where(course_id: Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id)).pluck(:id)).where.not(deleted_at: nil)
  end

  def trash_solutions
    @solutions = Solution.where(user_id: User.where(school_id: current_user.school_id).pluck(:id)).where.not(deleted_at: nil)
  end

  def trash_forums
    @forums = Forum.where(forumable_type: 'Course', forumable_id: Course.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id)).pluck(:id))
    .where(forumable_type: 'School', forumable_id: current_user.school_id).where.not(deleted_at: nil)
  end

  def trash_topics
    @topics = Topic.where(owner_id: User.where(school_id: current_user.school_id).pluck(:id)).where.not(deleted_at: nil)
  end

  def trash_posts
    @posts = Post.where(user_id: User.where(school_id: current_user.school_id).pluck(:id)).where.not(deleted_at: nil)
  end

  def restore
    klass = Object.const_get params[:klass]
    @object = klass.find(params[:id])
    if @object.update(deleted_at: nil)
      redirect_to "#{admin_trash_path}/#{params[:klass].downcase.pluralize}"
    end
  end

  def empty
    klass = Object.const_get params[:klass]
    klass.where(id: params[:ids]).delete_all
    redirect_to "#{admin_trash_path}/#{params[:klass].downcase.pluralize}", status: 303
  end
  
end