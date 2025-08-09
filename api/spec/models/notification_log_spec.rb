require 'rails_helper'

RSpec.describe NotificationLog, type: :model do
  it 'validates presence and status enum' do
    tenant = create(:tenant)
    contract = create(:contract, tenant: tenant)
    invoice = create(:invoice, tenant: tenant, contract: contract)
    log = NotificationLog.new(invoice: invoice, tenant: tenant, channel: 'email', status: 'sent', sent_at: Time.current)
    expect(log).to be_valid
  end
end
