require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user_correct) }

  describe "validations" do
    it "validates presence of email" do
      user = build(:user_correct, email: nil)
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "validates uniqueness of email" do
      create(:user_correct, email: "test@email.com")
      user = build(:user_correct, email: "test@email.com")
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to include("has already been taken")
    end
  end
end