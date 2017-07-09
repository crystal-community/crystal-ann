require "./application_controller"

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
      render("show.slang")
    else
      flash["warning"] = "Announcement with ID #{params["id"]} Not Found"
      redirect_to "/announcements"
    end
  end

  def new
    announcement = Announcement.new
    render("new.slang")
  end

  def create
    announcement = Announcement.new announcement_params

    if announcement.valid? && announcement.save
      flash["success"] = "Created Announcement successfully."
      redirect_to "/announcements"
    else
      flash["danger"] = "Could not create Announcement!"
      render("new.slang")
    end
  end

  def edit
    if announcement = Announcement.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "Announcement with ID #{params["id"]} Not Found"
      redirect_to "/announcements"
    end
  end

  def update
    if announcement = Announcement.find(params["id"])
      announcement.set_attributes announcement_params
      if announcement.valid? && announcement.save
        flash["success"] = "Updated Announcement successfully."
        redirect_to "/announcements/#{announcement.id}"
      else
        flash["danger"] = "Could not update Announcement!"
        render("edit.slang")
      end
    else
      flash["warning"] = "Announcement with ID #{params["id"]} Not Found"
      redirect_to "/announcements"
    end
  end

  def destroy
    if announcement = Announcement.find params["id"]
      announcement.destroy
    else
      flash["warning"] = "Announcement with ID #{params["id"]} Not Found"
    end
    redirect_to "/announcements"
  end

  private def announcement_params
    params.to_h.select %w(title description type)
  end

  private def query_param
    params["query"]?.try &.gsub /[^0-9A-Za-z_\-\s]/, ""
  end

  private def page_param
    [params.fetch("page", "1").to_i { 1 }, 1].max
  end
end
