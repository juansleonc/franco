module V1
  class PropertiesController < ApplicationController
    def index
      authorize Property
      render json: { data: Property.order(created_at: :desc) }
    end

    def show
      authorize property
      render json: { data: property }
    end

    def create
      authorize Property
      record = Property.new(property_params)
      if record.save
        render json: { data: record }, status: :created
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize property
      if property.update(property_params)
        render json: { data: property }
      else
        render json: { errors: property.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize property
      property.destroy!
      head :no_content
    end

    private

    def property
      @property ||= Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address, :unit, :active)
    end
  end
end
