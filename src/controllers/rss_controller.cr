class RSSController < Amber::Controller::Base
  def show
    announcements = Announcement.newest

    response.headers["Content-Type"] = "application/xml"
    render_template "rss/show.slang"
  end
end
