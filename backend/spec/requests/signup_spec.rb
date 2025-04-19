require 'rails_helper'

RSpec.describe "User signup", type: :request do
  let!(:user_attrs) { attributes_for(:user_correct) }

  it "should return a user's record correctly" do
    post '/signup', params: { user: { email: user_attrs[:email], password: user_attrs[:password], name: user_attrs[:name] } }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include_json(
      status: {
        code: 200,
        message: "Signed up successfully.",
        token: be_a(String),
        data: {
          user: {
            id: be_a(Integer),
            email: user_attrs[:email],
            name: user_attrs[:name],
            created_at: be_a(String),
            updated_at: be_a(String),
            jti: be_a(String)
          }
        }
      }
    )
  end

  it "should not allow users with duplicate emails" do
    post '/signup', params: { user: { email: user_attrs[:email], password: user_attrs[:password], name: user_attrs[:name] } }
    post '/signup', params: { user: { email: user_attrs[:email], password: user_attrs[:password], name: user_attrs[:name] } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include_json(
      status: {
        message: be_a(String)
      }
    )
  end
end
