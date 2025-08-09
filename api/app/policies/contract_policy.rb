class ContractPolicy < ApplicationPolicy
  def schedule_preview?
    true
  end
end
