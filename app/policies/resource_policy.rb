class ResourcePolicy < ApplicationPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @resource = resource
  end

  def index?
    admin_rights
  end

  def show?
    admin_rights
  end

  def create?
    teacher_rights
  end

  def new?
    create?
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
