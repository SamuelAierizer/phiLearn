class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @comment = comment
  end

  def index?
    admin_rights
  end

  def update?
    comment.owner(user)
  end

  def edit?
    update?
  end

  def destroy?
    admin_rights
  end
end
