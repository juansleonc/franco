class DedupPolicy < ApplicationPolicy
  def index?
    user&.role_admin? || user&.role_manager?
  end

  def update?
    user&.role_admin?
  end
end
