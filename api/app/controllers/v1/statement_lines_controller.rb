module V1
  class StatementLinesController < ApplicationController
    def match
      line = StatementLine.find(params[:id])
      authorize line, :update?
      payment_id = params.require(:payment_id)
      line.update!(match_status: "matched", matched_payment_id: payment_id)
      render json: { data: StatementLineSerializer.new(line) }
    end

    def ignore
      line = StatementLine.find(params[:id])
      authorize line, :update?
      line.update!(match_status: "ignored")
      render json: { data: StatementLineSerializer.new(line) }
    end
  end
end
