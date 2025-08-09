module Renderable
  extend ActiveSupport::Concern

  def render_collection(records, serializer:, pagy: nil)
    payload = {
      data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: serializer)
    }
    if pagy
      payload[:meta] = { page: pagy.page, pages: pagy.pages, count: pagy.count }
    end
    render json: payload
  end

  def render_resource(resource, serializer:, status: :ok)
    render json: { data: serializer.new(resource) }, status: status
  end

  def render_errors(errors, status: :unprocessable_content)
    render json: { errors: Array(errors) }, status: status
  end
end
