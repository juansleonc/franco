module V1
  class PropertiesController < ApplicationController
    include Pagy::Backend
    def index
      authorize Property
      pagy, records = pagy(Property.order(created_at: :desc))
      render_collection(records, serializer: PropertySerializer, pagy: pagy)
    end

    def show
      authorize property
      render_resource(property, serializer: PropertySerializer)
    end

    def create
      authorize Property
      record = Property.new(property_params)
      if record.save
        render_resource(record, serializer: PropertySerializer, status: :created)
      else
        render_errors(record.errors.full_messages)
      end
    end

    def update
      authorize property
      if property.update(property_params)
        render_resource(property, serializer: PropertySerializer)
      else
        render_errors(property.errors.full_messages)
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
