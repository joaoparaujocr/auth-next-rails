class Users::SessionsController < Devise::SessionsController
  include CurrentUserHelper
  include ActionController::Cookies

  respond_to :json
  before_action :authenticate_user!, only: [ :destroy ]

  private

  def respond_with(resource, _opt = {})
    @token = request.env["warden-jwt_auth.token"]
    headers["Authorization"] = @token

    cookies[:token] = {
      value: @token,
      httponly: true,
      secure: true,
      same_site: :none,
      expires: 1.week.from_now
    }

    render json: {
      status: {
        code: 200, message: "Logged in successfully."
      },
      data: {
        user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    puts "TEFEFEFEFEFEF"
    if current_user
      cookies.delete(:token)

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
