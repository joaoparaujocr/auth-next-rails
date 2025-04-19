class Users::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:me]

  def me
    render json: {
      status: {
        code: 200,
        message: 'Successful!'
      },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end
end