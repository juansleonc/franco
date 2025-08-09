# Ensures top-level Banking module methods are available when autoloading
require_dependency "banking/client"

module Banking
  class << self
    def client
      @client ||= build_client
    end

    def reset_client!
      @client = nil
    end
  end
end
