module V1
  class HealthsController < ActionController::API
    def show
      render json: { status: "ok" }
    end
  end
end
