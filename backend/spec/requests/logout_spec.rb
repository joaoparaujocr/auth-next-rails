require 'rails_helper'

RSpec.describe "User logout", type: :request do
  let!(:user_correct) { create(:user_correct) }

  it "should be possible to log out" do
    post '/login', params: { user: { email: user_correct.email, password: user_correct.password } }
    token = JSON.parse(response.body)['status']["token"]

    delete '/logout', headers: { 'Authorization': "Bearer #{token}" }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include_json(
      status: 200,
      message: "Logged out successfully."
    )
  end
end
