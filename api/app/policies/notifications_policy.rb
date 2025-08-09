class NotificationsPolicy < ApplicationPolicy
  def index?
    user&.role_admin? || user&.role_manager?
  end
  def create?
    user&.role_admin? || user&.role_manager?
  end
end
