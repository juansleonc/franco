module Invoicing
  class GenerateMonthlyJob < ApplicationJob
    queue_as :default

    def perform(as_of: Date.current)
      Invoicing::Generator.new(as_of: as_of).call
    end
  end
end
