module V1
  class DunningController < ApplicationController
    def candidates
      authorize Invoice, :index?
      as_of = params[:as_of].present? ? Date.parse(params[:as_of]) : Date.current
      pairs = Dunning::Scheduler.new(as_of: as_of).candidates
      render json: { data: pairs.map { |inv, stage| { invoice_id: inv.id, tenant_id: inv.tenant_id, due_on: inv.due_on, amount_cents: inv.amount_cents, balance_cents: inv.balance_cents, stage: stage } } }
    end
  end
end
