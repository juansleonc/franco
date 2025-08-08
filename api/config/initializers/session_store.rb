# API-only: enable cookie store minimally to satisfy Devise sign_in without redirects
Rails.application.config.session_store :disabled
