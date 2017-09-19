module Helpers::TimeAgoHelper
  extend self

  def time_ago_in_words(time)
    diff = Time.now - time

    case diff
    when 0.seconds..1.minute
      "just now"
    when 1.minute..2.minutes
      "a minute ago"
    when 2.minutes..1.hour
      "#{(diff / 60).to_i} minutes ago"
    when 1.hour..2.hours
      "an hour ago"
    when 2.hours..1.day
      "#{((diff / 60) / 60).to_i} hours ago"
    when 1.day..2.days
      "a day ago"
    when 2.days..1.week
      "#{((diff) / (60 * 60 * 24)).to_i} days ago"
    when 1.week..2.weeks
      "a week ago"
    else
      "#{((diff) / (60 * 60 * 24 * 7)).to_i} weeks ago"
    end
  end
end
