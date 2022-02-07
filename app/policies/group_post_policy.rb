class GroupPostPolicy < ApplicationPolicy
  attr_reader :user, :group_post

  def initialize(user, group_post)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @group_post = group_post
  end

  def update?
    admin_rights || (group_post.user_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end