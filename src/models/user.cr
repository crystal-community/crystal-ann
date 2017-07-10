require "granite_orm/adapter/pg"

class User < Granite::ORM
  adapter pg

  # id : Int64 primary key is created for you
  field name : String
  field uid : String
  field provider : String
  timestamps

  def can_update?(announcement)
    announcement.try &.user_id == id
  end
end
