module V1
  class ContractsController < ApplicationController
    def index
      authorize Contract
      records = Contract.order(created_at: :desc)
      render json: { data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: ContractSerializer) }
    end

    def show
      authorize contract
      render json: { data: ContractSerializer.new(contract) }
    end

    def create
      authorize Contract
      record = Contract.new(contract_params)
      if record.save
        render json: { data: ContractSerializer.new(record) }, status: :created
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize contract
      if contract.update(contract_params)
        render json: { data: ContractSerializer.new(contract) }
      else
        render json: { errors: contract.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize contract
      contract.destroy!
      head :no_content
    end

    def schedule_preview
      authorize Contract, :schedule_preview?
      start_on = Date.parse(params.require(:start_on))
      due_day = params.require(:due_day).to_i
      months = (params[:months] || 12).to_i
      schedule = []
      current = start_on
      months.times do
        month_start = Date.new(current.year, current.month, 1)
        day = [due_day, 28].min
        due_date = Date.new(month_start.year, month_start.month, day)
        due_date += 1.month if due_date < current
        schedule << { due_on: due_date }
        current = month_start.next_month
      end
      render json: { schedule: schedule }
    end

    private

    def contract
      @contract ||= Contract.find(params[:id])
    end

    def contract_params
      params.require(:contract).permit(:property_id, :tenant_id, :start_on, :end_on, :due_day, :monthly_rent, :active)
    end
  end
end
