class BoardPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def destroy?
    update?
  end

  def show?
    true
  end
end
