if ENV['CI'] || ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov_json_formatter'
  require 'simplecov-lcov'

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::LcovFormatter
  ])

  SimpleCov.start 'rails' do
    enable_coverage :branch
    add_filter '/spec/'
  end
  SimpleCov.minimum_coverage 70
  SimpleCov.minimum_branch_coverage 50
  SimpleCov.coverage_dir 'coverage'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
