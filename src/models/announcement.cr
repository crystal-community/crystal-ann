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
  field user_id : Int64
  field description : String
  timestamps

  validate :title, "is too short",
    ->(this : Announcement) { this.title.to_s.size >= 5 }

  validate :title, "is too long",
    ->(this : Announcement) { this.title.to_s.size <= 100 }

  validate :type, "is not selected",
    ->(this : Announcement) { TYPES.keys.includes? this.type }

  validate :description, "is too short",
    ->(this : Announcement) { this.description.to_s.size >= 10 }

  validate :description, "is too long",
    ->(this : Announcement) { this.description.to_s.size <= 4000 }

  def self.search(query, per_page = nil, page = 1, type = nil)
    q = %Q{
      WHERE (title ILIKE $1 OR description ILIKE $1) #{(type ? "AND type = $4" : "")}
      ORDER BY created_at DESC
      LIMIT $2 OFFSET $3
    }
    parameters = if type
                   ["%#{query}%", per_page, (page - 1) * per_page, type]
                 else
                   ["%#{query}%", per_page, (page - 1) * per_page]
                 end
    self.all q, parameters
  end

  def self.count(query, type = nil)
    parameters = if type
                   ["%#{query}%", type]
                 else
                   "%#{query}%"
                 end
    @@adapter.open do |db|
      db.scalar(%Q{
        SELECT COUNT(*) FROM announcements
        WHERE (title ILIKE $1 OR description ILIKE $1) #{(type ? "AND type = $2" : "")}
      }, parameters).as(Int64)
    end
  end

  def self.newest(from = 2.weeks.ago)
    Announcement.all("WHERE created_at > $1 ORDER BY created_at DESC", from)
  end

  def next
    Announcement.all("WHERE created_at > $1 ORDER BY created_at LIMIT 1", created_at).first?
  end

  def prev
    Announcement.all("WHERE created_at < $1 ORDER BY created_at DESC LIMIT 1", created_at).first?
  end

  def self.find_by_hashid(hashid)
    if id = (HASHIDS.decode hashid).first?
      Announcement.find id
    end
  end

  def hashid
    HASHIDS.encode([id.not_nil!]) if id
  end

  def short_path
    id ? "/=#{hashid}" : nil
  end

  def typename
    TYPES[type]
  end

  def typename_underscore
    typename.tr(" ", "").underscore
  end

  def self.reverse_typename_underscore(typename)
    index = nil
    TYPES.each { |i, type| index = i if type.tr(" ", "").underscore == typename }
    index
  end

  def user
    User.find(user_id)
  end

  def content
    Markdown.to_html(description.not_nil!)
  end
end
