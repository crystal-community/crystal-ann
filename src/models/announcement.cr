require "granite_orm/adapter/pg"
require "markdown"

class Announcement < Granite::ORM
  TYPES = {
    0 => "Blog Post",
    1 => "Project Update",
    2 => "Conference",
    3 => "Meetup",
    4 => "Podcast",
    5 => "Screencast",
    6 => "Video",
    7 => "Other",
  }

  adapter pg

  field type : Int32
  field title : String
  field description : String
  timestamps

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

  def self.search(query, per_page = nil, page = 1)
    self.all %q{
      WHERE title ILIKE $1 OR description ILIKE $1
      ORDER BY created_at DESC
      LIMIT $2 OFFSET $3
    }, ["%#{query}%", per_page, (page - 1) * per_page]
  end

  def self.count(query)
    @@adapter.open do |db|
      db.scalar(%q{
        SELECT COUNT(*) FROM announcements
        WHERE title ILIKE $1 OR description ILIKE $1
      }, "%#{query}%").as(Int64)
    end
  end

  def self.newest(from = 2.weeks.ago)
    Announcement.all("WHERE created_at > $1 ORDER BY created_at DESC", from)
  end

  def typename
    TYPES[type]
  end

  def content
    Markdown.to_html(description.not_nil!)
  end
end
