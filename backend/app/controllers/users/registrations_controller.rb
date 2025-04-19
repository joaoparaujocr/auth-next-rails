class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: {
          code: 200,
          message: "Signed up successfully.",
        },
        data: {
          token: current_token,
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }, status: :ok
    else
      render json: {
        status: {
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}",
          code: 422
        }
      }, status: :unprocessable_entity
    end
  end

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
