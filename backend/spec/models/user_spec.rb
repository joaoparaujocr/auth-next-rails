require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user_correct) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:name) }
  end

  describe "#display_name" do
    it "returns the name and email" do
      user = build(:user_correct)
      expect(user.display_name).to eq("João <joao@email.com>")
    end
  end
end
