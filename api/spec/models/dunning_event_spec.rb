require 'rails_helper'

RSpec.describe DunningEvent, type: :model do
  it 'is valid with invoice and stage and sent_at' do
    inv = create(:invoice)
    event = described_class.new(invoice: inv, stage: 'gentle', sent_at: Time.current)
    expect(event).to be_valid
  end
end
