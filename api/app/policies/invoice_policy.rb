class InvoicePolicy < ApplicationPolicy
  def index?
    user.present?
  end
end
