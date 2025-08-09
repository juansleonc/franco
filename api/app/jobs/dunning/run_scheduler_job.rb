module Dunning
  class RunSchedulerJob < ApplicationJob
    queue_as :default

    def perform(as_of: Date.current)
      scheduler = Dunning::Scheduler.new(as_of: as_of)
      scheduler.candidates.each do |invoice, stage|
        # Placeholder: emit event/log. Real implementation could enqueue mailers or notifications.
        Rails.logger.info("DUNNING: invoice=#{invoice.id} stage=#{stage}")
      end
    end
  end
end
