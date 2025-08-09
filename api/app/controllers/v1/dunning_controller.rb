module V1
  class DunningController < ApplicationController
    def candidates
      authorize Invoice, :index?
      as_of = params[:as_of].present? ? Date.parse(params[:as_of]) : Date.current
      pairs = Dunning::Scheduler.new(as_of: as_of).candidates
      data = pairs.map do |inv, stage|
        # persist event (idempotency via unique index)
        DunningEvent.find_or_create_by!(invoice_id: inv.id, stage: stage.to_s) do |ev|
          ev.sent_at = Time.current
        end
        { invoice_id: inv.id, tenant_id: inv.tenant_id, due_on: inv.due_on, amount_cents: inv.amount_cents, balance_cents: inv.balance_cents, stage: stage }
      end
      render json: { data: data }
    end
  end
end
