require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password" do
    user = described_class.new(email: "a@b.com", password: "Password123!", password_confirmation: "Password123!")
    expect(user).to be_valid
  end

  it "requires email" do
    user = described_class.new(password: "Password123!", password_confirmation: "Password123!")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end
end
