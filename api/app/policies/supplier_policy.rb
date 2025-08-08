class SupplierPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def import?
    user.present?
  end
end
