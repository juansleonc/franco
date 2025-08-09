module V1
  class InvoicingController < ApplicationController
    def generate_monthly
      authorize Contract, :index?
      as_of = params[:as_of].present? ? Date.parse(params[:as_of]) : Date.current
      generated = Invoicing::Generator.new(as_of: as_of).call
      render json: { generated: generated }
    end
  end
end
