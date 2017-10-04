require "granite_orm/adapter/pg"
require "markdown"
require "autolink"

class Announcement < Granite::ORM::Base
  TYPES = {
    0 => "blog_post",
    1 => "project_update",
    2 => "conference",
    3 => "meetup",
    4 => "podcast",
    5 => "screencast",
    6 => "video",
    7 => "other",
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

  def self.search(query, per_page = nil, page = 1, type = nil, user_id = nil)
    q = %Q{
      WHERE (title ILIKE $1 OR description ILIKE $1)
        #{"AND type='#{type}'" if type}
        #{"AND user_id='#{user_id}'" if user_id}
        ORDER BY created_at DESC
        LIMIT $2 OFFSET $3
    }
    parameters = ["%#{query}%", per_page, (page - 1) * per_page]
    self.all q, parameters
  end

  def self.count(query, type = nil, user_id = nil)
    @@adapter.open do |db|
      db.scalar(%Q{
        SELECT COUNT(*) FROM announcements
          WHERE (title ILIKE $1 OR description ILIKE $1)
          #{"AND type='#{type}'" if type}
          #{"AND user_id='#{user_id}'" if user_id}
      }, "%#{query}%").as(Int64)
    end
  end

  def self.newest(from = 2.weeks.ago)
    Announcement.all("WHERE created_at > $1 ORDER BY created_at DESC", from)
  end

  def self.typename(type)
    TYPES[type].split("_").join(" ").capitalize
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
    Announcement.typename(type)
  end

  def user
    User.find(user_id)
  end

  def content
    Autolink.auto_link(Markdown.to_html(description.not_nil!))
  end

  def self.random
    Announcement.all("ORDER BY RANDOM() LIMIT 1").first
  end
end
