require "../helpers/*"

class ApplicationController < Amber::Controller::Base
  include Helpers::QueryHelper
  include Helpers::PageTitleHelper

  before_action do
    all { redirect_force_ssl }
  end

  LAYOUT = "application.slang"

  @current_user : User?

  protected def current_user
    return @current_user = User.find_by(:login, "veelenga") if AMBER_ENV == "development"
    @current_user ||= User.find_by(:id, session["user_id"]) if session["user_id"]
  end

  protected def current_user!
    current_user.not_nil!
  end

  protected def signed_in?
    current_user != nil
  end

  protected def can_update?(announcement)
    current_user.try &.can_update? announcement
  end

  protected def redirect_force_ssl
    if SITE.force_ssl && request.headers["x-forwarded-proto"]? != "https"
      redirect_to "https://#{request.host_with_port}#{request.path}"
    end
  end
end
