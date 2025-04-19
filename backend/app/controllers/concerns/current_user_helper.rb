module CurrentUserHelper
  extend ActiveSupport::Concern

  def current_user
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split.last

      return unless token

      jwt_payload = JWT.decode(token, ENV["DEVISE_JWT_SECRET_KEY"]).first
      @current_user ||= User.find(jwt_payload["sub"].to_i)
    end
  rescue JWT::DecodeError
    nil
  end

  def authenticate_user!
    render json: { status: { message: "Unauthorized", code: 401 } }, status: :unauthorized unless current_user
  end
end
