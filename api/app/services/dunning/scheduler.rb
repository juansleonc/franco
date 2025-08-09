module Dunning
  class Scheduler
    STAGES = [
      { name: :gentle, min_days: 7, max_days: 14 },
      { name: :reminder, min_days: 15, max_days: 30 },
      { name: :final, min_days: 31, max_days: 10_000 }
    ].freeze

    def initialize(as_of: Date.current)
      @as_of = as_of
    end

    def candidates
      invoices = Invoice.pending.where("due_on < ?", @as_of)
      invoices.map { |inv| [ inv, stage_for(inv) ] }.select { |_, stage| stage }
    end

    private

    def stage_for(invoice)
      days = (@as_of - invoice.due_on).to_i
      rule = STAGES.find { |s| days.between?(s[:min_days], s[:max_days]) }
      rule&.fetch(:name, nil)
    end
  end
end
