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

    def preview
      authorize Invoice, :index?
      as_of = params[:as_of].present? ? Date.parse(params[:as_of]) : Date.current
      pairs = Dunning::Scheduler.new(as_of: as_of).candidates
      # no persistence, only preview
      data = pairs.map do |inv, stage|
        { invoice_id: inv.id, tenant_id: inv.tenant_id, stage: stage, email: inv.tenant.email, phone: inv.tenant.phone }
      end
      render json: { data: data }
    end

    def send_bulk
      authorize Invoice, :update?
      invoice_ids = Array(params[:invoice_ids])
      channels = Array(params[:channels]).presence || %w[email sms]
      enqueued = []
      invoice_ids.each do |id|
        enqueued << Dunning::SendNotificationsJob.perform_later(invoice_id: id, channels: channels)
      end
      render json: { data: { enqueued: enqueued.size } }
    end
  end
end
