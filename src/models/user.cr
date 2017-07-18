require "granite_orm/adapter/pg"

class User < Granite::ORM
  adapter pg

  # id : Int64 primary key is created for you
  field name : String
  field login : String
  field uid : String
  field provider : String
  field role : String
  timestamps

  validate :login, "can't be blank", ->(this : User) { !this.login.to_s.blank? }
  validate :uid, "can't be blank", ->(this : User) { !this.uid.to_s.blank? }
  validate :provider, "can't be blank", ->(this : User) { !this.provider.to_s.blank? }

  def can_update?(announcement : Announcement)
    admin? || announcement.user_id == id
  end

  def admin?
    role == "admin"
  end

  def self.find_by_uid_and_provider(uid, provider)
    User.all("WHERE uid = $1 AND provider = $2 LIMIT 1", [uid, provider]).first?
  end
end
