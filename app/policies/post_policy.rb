class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @post = post
  end

  def update?
    admin_rights
  end

  def edit?
    update?
  end

  def destroy?
    admin_rights
  end

end