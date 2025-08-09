require 'rails_helper'

RSpec.describe 'Sms.client', type: :model do
  around do |ex|
    orig = ENV.to_hash
    ENV.delete('TWILIO_ACCOUNT_SID')
    ex.run
    ENV.replace(orig)
  end

  it 'returns NullClient by default' do
    expect(Sms.client).to be_a(Sms::NullClient)
  end
end
