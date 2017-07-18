require "../spec_helper"
require "../../src/models/**"

def user(**params)
  attributes = {
    :id       => 1_i64,
    :uid      => "123123",
    :login    => "johndoe",
    :provider => "github",
  }.merge!(params.to_h)

  User.new attributes
end

def announcement(**params)
  attributes = {
    :id          => 1_i64,
    :title       => "title",
    :description => "description",
    :type        => Announcement::TYPES.keys.first,
  }.merge!(params.to_h)

  Announcement.new attributes
end
