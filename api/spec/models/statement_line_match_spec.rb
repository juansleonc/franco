require 'rails_helper'

RSpec.describe StatementLine, type: :model do
  it 'updates match status to matched when linked to payment' do
    line = create(:statement_line)
    pay = create(:payment)
    line.update!(matched_payment: pay, match_status: 'matched')
    expect(line).to be_match_status_matched
    expect(line.matched_payment_id).to eq(pay.id)
  end
end
