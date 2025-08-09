module Dunning
  module SmsTemplates
    module_function

    def overdue(invoice:)
      tenant_name = invoice.tenant.full_name
      due_on = invoice.due_on
      amount = format('%.2f', invoice.balance_cents.to_i / 100.0)
      currency = invoice.currency
      "#{tenant_name}, your rent invoice is due on #{due_on}. Amount due: #{amount} #{currency}."
    end
  end
end
