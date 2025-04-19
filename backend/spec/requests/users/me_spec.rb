require 'rails_helper'

RSpec.describe "/users/me", type: :request do
  let!(:user_correct) { create(:user_correct) }

  it "should return information about the logged in user" do
    post '/login', params: { user: { email: user_correct.email, password: user_correct.password } }

    token = JSON.parse(response.body)['status']['token']

    get '/users/me', headers: { 'Authorization': "Bearer #{token}" }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include_json(
      status: {
        code: 200,
        message: 'Successful!'
      },
      data: {
        id: be_a(Integer),
        email: be_a(String),
        name: be_a(String)
      }
    )
  end

  it "should not be possible to access the me route without token" do
    get '/users/me'

    expect(response).to have_http_status(:unauthorized)
    expect(JSON.parse(response.body)).to include_json(
      status: {
        code: 401,
        message: 'Unauthorized'
      }
    )
  end
end
