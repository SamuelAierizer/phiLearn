class ForumPolicy < ApplicationPolicy
  attr_reader :user, :forum

  def initialize(user, forum)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @forum = forum
  end

  def school_toggle?
    admin_rights
  end

  def courses_toggle?
    admin_rights
  end

end