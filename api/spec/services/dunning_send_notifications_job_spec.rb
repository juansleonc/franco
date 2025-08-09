require 'rails_helper'

RSpec.describe Dunning::SendNotificationsJob, type: :job do
  it 'enqueues and performs sending with logs' do
    allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).and_return(true)
    tenant = create(:tenant, email: 't@example.com', phone: '+1000')
    contract = create(:contract, tenant: tenant)
    invoice = create(:invoice, tenant: tenant, contract: contract)

    expect {
      described_class.perform_now(invoice_id: invoice.id, channels: %w[email sms])
    }.to change(NotificationLog, :count).by_at_least(1)
  end
end
