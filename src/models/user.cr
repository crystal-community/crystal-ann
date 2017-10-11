require "granite_orm/adapter/pg"

class User < Granite::ORM::Base
  adapter pg

  # id : Int64 primary key is created for you
  field name : String
  field login : String
  field uid : String
  field provider : String
  field role : String
  field handle : String
  timestamps

  validate :login, "can't be blank", ->(this : User) { !this.login.to_s.blank? }
  validate :uid, "can't be blank", ->(this : User) { !this.uid.to_s.blank? }
  validate :provider, "can't be blank", ->(this : User) { !this.provider.to_s.blank? }

  def can_update?(announcement : Announcement)
    admin? || announcement.user_id == id
  end

  def me?(user : User)
    user.id == id
  end

  def admin?
    role == "admin"
  end

  def avatar_url(size : Int32 = 400)
    "#{github_url}.png?s=#{size}"
  end

  def github_url
    "https://github.com/#{login}"
  end

  def twitter_url
    return nil if handle.to_s.blank?
    "https://twitter.com/#{handle}"
  end

  def total_announcements
    Announcement.count(nil, user_id: id)
  end

  def self.find_by_uid_and_provider(uid, provider)
    User.all("WHERE uid = $1 AND provider = $2 LIMIT 1", [uid, provider]).first?
  end

  def self.find_by_login(login)
    User.all("WHERE login = $1 LIMIT 1", login).first?
  end
end
