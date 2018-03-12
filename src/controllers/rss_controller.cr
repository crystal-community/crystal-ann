class RSSController < Amber::Controller::Base
  include Helpers::TimeAgoHelper

  def show
    announcements = Announcement.newest

    respond_with do
      xml render "rss/show.slang", layout: false
    end
  end
end
