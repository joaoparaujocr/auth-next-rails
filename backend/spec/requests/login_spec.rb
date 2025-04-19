require 'rails_helper'

RSpec.describe "User login", type: :request do
  let!(:user_correct) { create(:user_correct) }
  let!(:user_Invalid_attrs) { attributes_for(:user_wrong) }

  it "should be returns a JWT token with valid credentials" do
    post '/login', params: { user: { email: user_correct.email, password: user_correct.password } }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include_json(
      status: {
        code: 200,
        message: 'Logged in successfully.'
      },
      data: {
        token: be_a(String),
        user: {
          id: be_a(Integer),
          email: user_correct.email,
          name: user_correct.name
        }
      }
    )
  end

  it "should be returns unauthorized with invalid credentials" do
    post '/login', params: { user: user_Invalid_attrs }

    expect(response).to have_http_status(:unauthorized)
  end
end
