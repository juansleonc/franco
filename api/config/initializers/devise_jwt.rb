Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { "changeme" }
    jwt.dispatch_requests = [
      [ "POST", %r{^/v1/auth/login$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/v1/auth/logout$} ]
    ]
    jwt.request_formats = {
      user: [ :json ]
    }
  end
end
