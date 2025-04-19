class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: {
          code: 200,
          message: "Signed up successfully.",
          token: current_token,
          data: { user: resource }
        }
      }, status: :ok
    else
      render json: {
        status: {
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
