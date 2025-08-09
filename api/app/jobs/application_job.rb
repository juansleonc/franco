class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # Semantic wrapper to allow unique enqueue in adapters that support it.
  # For others, this acts as a plain perform_later.
  def self.enqueue_once(**args)
    perform_later(**args)
  end
end
