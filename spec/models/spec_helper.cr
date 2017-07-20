require "../spec_helper"
require "../../src/models/**"

def user(**params)
  attributes = {
    :id       => 1_i64,
    :uid      => "123123",
    :login    => "johndoe",
    :provider => "github",
  } of Symbol => String | Int64

  params.each { |k, v| attributes[k] = v }
  User.new attributes
end

def announcement(**params)
  attributes = {
    :id          => 1_i64,
    :title       => "title",
    :description => "description",
    :type        => Announcement::TYPES.keys.first,
  } of Symbol => String | Int64 | Int32

  params.each { |k, v| attributes[k] = v }
  Announcement.new attributes
end
