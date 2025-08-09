module V1
  class OwnerStatementsController < ApplicationController
    def index
      authorize Property, :index?
      period = params.require(:period)
      Statements::Builder.new(period: period).call
      scope = OwnerStatement.where(period: period)
      scope = scope.where(property_id: params[:property_id]) if params[:property_id]
      render json: { data: ActiveModelSerializers::SerializableResource.new(scope, each_serializer: OwnerStatementSerializer) }
    end

    def show
      authorize Property, :show?
      st = OwnerStatement.find(params[:id])
      render json: { data: OwnerStatementSerializer.new(st) }
    end
  end
end
