FactoryBot.define do
  factory :user_correct, class: 'User' do
    name { "John Doe" }
    email { "john_doe@email.com" }
    password { "johndoe123" }
  end

  factory :user_wrong, class: 'User' do
    name { "Wrong Name" }
    email { "wrongemail@example.com" }
    password { "wrongpassword" }
  end
end