class Amber::Controller::Error < Amber::Controller::Base
  LAYOUT = "application.slang"

  def forbidden
    "403 - Forbidden"
  end

  def not_found
    "404 - Page not found"
  end

  def internal_server_error
    "500 - Internal server error"
  end
end
