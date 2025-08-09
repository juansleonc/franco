class SupplierPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.role_admin? || user&.role_manager? || user&.role_assistant?
  end

  def create?
    user&.role_admin? || user&.role_manager?
  end

  def import?
    user&.role_admin? || user&.role_manager?
  end
end
