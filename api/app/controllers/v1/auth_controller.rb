module V1
  class AuthController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :login ]

    def login
      user = User.find_for_database_authentication(email: params[:email])
      if user&.valid_password?(params[:password])
        # Issue JWT without persisting session (API-only)
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        response.set_header("Authorization", "Bearer #{token}") if token
        render json: { token: token, user: { id: user.id, email: user.email } }
      else
        render json: { error: "invalid_credentials" }, status: :unauthorized
      end
    end

    def logout
      sign_out(current_user) if current_user
      head :no_content
    end
  end
end
