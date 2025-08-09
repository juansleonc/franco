class StatementLinePolicy < ApplicationPolicy
  def update?
    user.present?
  end
end
