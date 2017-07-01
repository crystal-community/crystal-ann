require "granite_orm/adapter/pg"
require "markdown"

class Announcement < Granite::ORM
  TYPES = {
    0 => "Blog Post",
    1 => "Project Update",
    2 => "Conference",
    3 => "Meetup",
    4 => "Screencast",
    5 => "Video",
    6 => "Other",
  }

  adapter pg

  field type : Int32
  field title : String
  field description : String
  timestamps

  include Kemalyst::Validators

  validate :title, "is too short",
    ->(this : Announcement) { this.title.to_s.size >= 5 }

  validate :title, "is too long",
    ->(this : Announcement) { this.title.to_s.size <= 100 }

  validate :type, "is not valid",
    ->(this : Announcement) { TYPES.keys.includes? this.type }

  validate :description, "is too short",
    ->(this : Announcement) { this.description.to_s.size >= 10 }

  validate :description, "is too long",
    ->(this : Announcement) { this.description.to_s.size <= 4000 }

  def typename
    TYPES[type]
  end

  def content
    Markdown.to_html(description.not_nil!)
  end
end
