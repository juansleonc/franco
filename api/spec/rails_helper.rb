# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

# Disable coverage when generating Swagger (rswag dry-run) to avoid false failures
SWAGGER_MODE = ENV['RSWAG'] == 'true' || ARGV.any? { |a| a.include?('Rswag::Specs::SwaggerFormatter') || a == '--dry-run' }
unless SWAGGER_MODE
  require 'simplecov'
  SimpleCov.start 'rails' do
    enable_coverage :branch
    minimum_coverage 89
    # Per-file minimum disabled to avoid false failures on infra files
    add_filter '/app/controllers/application_controller.rb'
    add_filter '/app/controllers/health_controller.rb'
    add_filter '/app/controllers/v1/healths_controller.rb'
    add_filter '/app/policies/'
    add_filter '/config/'
    add_filter '/swagger/'
  end
end
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Ensure test database is up-to-date with migrations
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
require 'rspec/rails'
require 'devise'

Rails.application.config.hosts.clear if Rails.application.config.respond_to?(:hosts)

RSpec.configure do |config|
  # Enable ActiveJob test adapter helpers
  config.include ActiveJob::TestHelper

  config.before(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include FactoryBot::Syntax::Methods
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
