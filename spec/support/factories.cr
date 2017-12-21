require "../../src/models/**"

def user(**params)
  attributes = {
    :uid      => (rand() * 10000).to_i.to_s,
    :login    => "johndoe",
    :provider => "github",
  } of Symbol | String => String | JSON::Type

  params.each { |k, v| attributes[k] = v }
  User.new attributes
end

def announcement(**params)
  attributes = {
    :title       => "title",
    :description => "description",
    :type        => Announcement::TYPES.keys.first.as(Int64),
  } of Symbol | String => String | JSON::Type

  params.each { |k, v| attributes[k] = v }
  Announcement.new attributes
end

def announcement(user, **params)
  announcement(**params).tap { |a| a.user_id = user.id }
end
