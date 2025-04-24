module CurrentUserHelper
  extend ActiveSupport::Concern
  include ActionController::Cookies

  def current_user
    token = cookies[:token] || (request.headers["Authorization"] && request.headers["Authorization"].split(" ").last)

    return unless token

    jwt_payload = JWT.decode(token, ENV["DEVISE_JWT_SECRET_KEY"], true, algorithm: "HS256").first
    @current_user ||= User.find(jwt_payload["sub"].to_i)
  rescue JWT::DecodeError
    nil
  end

  def authenticate_user!
    render json: { status: { message: "Unauthorized", code: 401 } }, status: :unauthorized unless current_user
  end
end
