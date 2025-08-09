module V1
  class BankingController < ApplicationController
    def accounts
      authorize :banking, :index?
      render json: { data: Banking.client.list_accounts }
    end

    def sync
      authorize :banking, :create?
      as_of = params[:as_of] || Date.today.to_s
      render json: { data: Banking.client.sync(as_of: Date.parse(as_of)) }
    end
  end
end
