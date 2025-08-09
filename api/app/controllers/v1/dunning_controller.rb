module V1
  class DunningController < ApplicationController
    def candidates
      authorize Invoice, :index?
      as_of = params[:as_of].present? ? Date.parse(params[:as_of]) : Date.current
      pairs = Dunning::Scheduler.new(as_of: as_of).candidates
      data = pairs.map do |inv, stage|
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
      # Basic tenant-level throttling: max 1 job per tenant per 5 minutes per channel
      throttled = 0
      enqueued = []
      invoice_ids.each do |id|
        invoice = Invoice.find(id)
        channels.each do |ch|
          recent = NotificationLog.where(tenant_id: invoice.tenant_id, channel: ch).where("sent_at > ?", 5.minutes.ago)
          if recent.exists?
            throttled += 1
            next
          end
        end
        enqueued << Dunning::SendNotificationsJob.perform_later(invoice_id: id, channels: channels)
      end
      render json: { data: { enqueued: enqueued.size, throttled: throttled } }
    end
  end
end
