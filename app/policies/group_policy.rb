class GroupPolicy < ApplicationPolicy
  attr_reader :user, :group

  def initialize(user, group)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @group = group
  end

  def show?
    (group.hasMember(user) || admin_rights) && group.deleted_at.nil?
  end

  def create?
    teacher_rights
  end

  def update?
    admin_rights || group.hasAdmin(user)
  end

  def edit?
    update?
  end

  def destroy?
    admin_rights
  end

  def giveAdmin?
    update?
  end

  def mass_delete?
    update?
  end

  def reset_code?
    update?
  end

  def widgets?
    show?
  end

  def activity?
    show?
  end

end