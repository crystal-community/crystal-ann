class RSSController < Amber::Controller::Base
  include Helpers::TimeAgoHelper

  def show
    response.headers["Content-Type"] = "application/xml"

    announcements = Announcement.newest
    render "rss/show.slang", layout: false
  end
end
