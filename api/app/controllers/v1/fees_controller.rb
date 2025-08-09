module V1
  class FeesController < ApplicationController
    def calculate
      authorize Contract, :index?
      period = params.require(:period)
      generated = Fees::Calculator.new(period: period).call
      render json: { generated: generated }
    end
  end
end
