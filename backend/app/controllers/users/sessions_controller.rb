class Users::SessionsController < Devise::SessionsController
  include CurrentUserHelper

  respond_to :json
  before_action :authenticate_user!, only: [:destroy]

  private

  def respond_with(resource, _opt = {})
    @token = request.env["warden-jwt_auth.token"]
    headers["Authorization"] = @token

    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        token: @token,
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
