require "./application_controller"
require "../workers/tweet_announcement"

class AnnouncementController < ApplicationController
  PER_PAGE = 10

  def index
    query, current_page = query_param, page_param
    total_pages = Announcement.count(query).fdiv(PER_PAGE).ceil.to_i

    announcements = Announcement.search(query, per_page: PER_PAGE, page: current_page)
    render("index.slang")
  end

  def show
    if announcement = Announcement.find params["id"]
      newer, older = announcement.next, announcement.prev
      render("show.slang")
    else
      redirect_to "/announcements"
    end
  end

  def new
    announcement = Announcement.new
    render("new.slang")
  end

  def create
    check_signed_in!

    announcement = Announcement.new announcement_params
    announcement.user_id = current_user!.id

    if announcement.valid? && announcement.save
      Workers::TweetAnnouncement.async.perform(announcement.id.not_nil!) rescue nil
      redirect_to "/announcements"
    else
      render("new.slang")
    end
  end

  def edit
    announcement = find_announcement
    if announcement && can_update?(announcement)
      render("edit.slang")
    else
      redirect_to "/announcements"
    end
  end

  def update
    announcement = find_announcement
    if announcement && can_update?(announcement)
      announcement.set_attributes announcement_params
      if announcement.valid? && announcement.save
        redirect_to "/announcements/#{announcement.id}"
      else
        render("edit.slang")
      end
    else
      redirect_to "/announcements"
    end
  end

  def destroy
    announcement = find_announcement
    announcement.destroy if announcement && can_update?(announcement)
    redirect_to "/announcements"
  end

  private def announcement_params
    params.to_h.select %w(title description type)
  end

  private def find_announcement
    Announcement.find params["id"]
  end

  private def query_param
    params["query"]?.try &.gsub /[^0-9A-Za-z_\-\s]/, ""
  end

  private def page_param
    [params.fetch("page", "1").to_i { 1 }, 1].max
  end
end
