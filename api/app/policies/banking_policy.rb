class BankingPolicy < ApplicationPolicy
  def index?
    user&.role_admin? || user&.role_manager?
  end

  def create?
    user&.role_admin?
  end
end
