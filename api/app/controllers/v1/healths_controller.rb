module V1
  class HealthsController < ApplicationController
    def show
      render json: { status: "ok" }
    end
  end
end
