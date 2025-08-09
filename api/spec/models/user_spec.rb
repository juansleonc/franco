require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password" do
    user = User.new(email: "a@b.com", password: "Password123!", password_confirmation: "Password123!")
    expect(user.valid?).to be_truthy
  end

  it "requires email" do
    user = User.new(password: "Password123!", password_confirmation: "Password123!")
    expect(user.valid?).to be_falsey
    expect(user.errors[:email]).to be_present
  end
end
