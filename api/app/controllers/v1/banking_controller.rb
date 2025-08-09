module V1
  class BankingController < ApplicationController
    def accounts
      authorize :banking, :index?
      render json: { data: [ { id: 'acc_001', name: 'Default Operating', currency: 'USD' } ] }
    end

    def sync
      authorize :banking, :create?
      as_of = params[:as_of] || Date.today.to_s
      # No-op stub for now
      render json: { data: { synced: true, as_of: as_of } }
    end
  end
end
