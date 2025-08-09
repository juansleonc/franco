class NotificationsPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
