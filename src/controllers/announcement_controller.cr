require "./application_controller"
require "../workers/tweet_announcement"

class AnnouncementController < ApplicationController
  PER_PAGE = 10

  def index
    query, current_page, type, user_id = query_param, page_param, type_param, user_id_param
    total_pages = Announcement.count(query, type, user_id).fdiv(PER_PAGE).ceil.to_i

    announcements = Announcement.search(query, per_page: PER_PAGE, page: current_page, type: type, user_id: user_id)
    render("index.slang")
  end

  def show
    if announcement = Announcement.find params["id"]
      newer, older = announcement.next, announcement.prev
      render("show.slang")
    else
      redirect_to "/"
    end
  end

  def new
    announcement = Announcement.new
    render("new.slang")
  end

  def create
    return redirect_to("/announcements/new") unless signed_in?

    announcement = Announcement.new announcement_params
    announcement.user_id = current_user!.id

    if announcement.valid? && announcement.save
      Workers::TweetAnnouncement.new.perform(announcement.id.not_nil!)
      redirect_to "/"
    else
      render("new.slang")
    end
  end

  def edit
    return redirect_to("/") unless signed_in?

    announcement = find_announcement
    if announcement && can_update?(announcement)
      render("edit.slang")
    else
      redirect_to "/"
    end
  end

  def update
    return redirect_to("/") unless signed_in?

    announcement = find_announcement
    if announcement && can_update?(announcement)
      announcement.set_attributes announcement_params
      if announcement.valid? && announcement.save
        redirect_to "/announcements/#{announcement.id}"
      else
        render("edit.slang")
      end
    else
      redirect_to "/"
    end
  end

  def destroy
    return redirect_to("/") unless signed_in?

    announcement = find_announcement
    announcement.destroy if announcement && can_update?(announcement)
    redirect_to "/"
  end

  def expand
    if announcement = Announcement.find_by_hashid(params["hashid"])
      redirect_to "/announcements/#{announcement.id}"
    else
      redirect_to "/"
    end
  end

  def random
    announcement = Announcement.random
    redirect_to "/announcements/#{announcement.id}"
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

  private def type_param
    (type = params["type"]?) && Announcement::TYPES.key(type) { -1 }
  end

  private def user_id_param
    User.find_by_login(params["user"]?).try(&.id)
  end
end
