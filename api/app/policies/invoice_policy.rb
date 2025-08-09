class InvoicePolicy < ApplicationPolicy
  def index?
    user&.role_admin? || user&.role_manager? || user&.role_assistant?
  end
end
