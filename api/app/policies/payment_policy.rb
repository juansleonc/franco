class PaymentPolicy < ApplicationPolicy
  def index?
    user&.role_admin? || user&.role_manager? || user&.role_assistant?
  end

  def show?
    user&.role_admin? || user&.role_manager? || user&.role_assistant?
  end

  def create?
    user&.role_admin? || user&.role_manager?
  end

  def update?
    user&.role_admin? || user&.role_manager?
  end
end
