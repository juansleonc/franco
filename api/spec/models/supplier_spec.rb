require 'rails_helper'

RSpec.describe Supplier, type: :model do
  it "validates presence of name and tax_id" do
    supplier = Supplier.new
    expect(supplier.valid?).to be_falsey
    expect(supplier.errors[:name]).to be_present
    expect(supplier.errors[:tax_id]).to be_present
  end

  it "validates uniqueness of tax_id" do
    user = create(:user)
    create(:supplier, tax_id: "X1", created_by_user: user)
    dup = Supplier.new(name: "Dup", tax_id: "X1", email: "a@b.com", created_by_user: user)
    expect(dup.valid?).to be_falsey
    expect(dup.errors[:tax_id]).to be_present
  end
end
