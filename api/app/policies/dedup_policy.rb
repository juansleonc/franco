class DedupPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def update?
    user.present?
  end
end
