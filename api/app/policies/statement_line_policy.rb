class StatementLinePolicy < ApplicationPolicy
  def update?
    user&.role_admin? || user&.role_manager?
  end
end
