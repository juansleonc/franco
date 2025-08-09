require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Disable host authorization in test to avoid blocked host errors
  config.middleware.delete(ActionDispatch::HostAuthorization)
  config.hosts = [ "www.example.com", "example.org", "localhost", "127.0.0.1" ]

  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = true
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Provide minimal Active Record encryption keys for tests
  config.active_record.encryption.primary_key = ENV.fetch('AR_ENC_PRIMARY_KEY', 'x' * 32)
  config.active_record.encryption.deterministic_key = ENV.fetch('AR_ENC_DETERMINISTIC_KEY', 'y' * 32)
  config.active_record.encryption.key_derivation_salt = ENV.fetch('AR_ENC_SALT', 'z' * 32)

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Print deprecation notices to the stderr.
  config.active_support.report_deprecations = true

  # Raise error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end
