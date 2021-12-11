class SchoolPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def stats?
    teacher_rights
  end

  def overview?
    admin_rights
  end

  def edit?
    admin_rights
  end

  def update?
    admin_rights
  end

  def destroy?
    admin_rights
  end

end