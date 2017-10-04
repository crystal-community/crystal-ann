require "granite_orm/adapter/pg"

class Recommendation < Granite::ORM::Base
  adapter pg

  belongs_to :announcement

  field announcement_id : Int32
  field recommended_id : Int32
  timestamps
end
