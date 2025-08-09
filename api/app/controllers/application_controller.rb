class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Renderable

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "forbidden" }, status: :forbidden
  end
end
