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
      "#{diff.minutes} minutes ago"
    when 1.hour..2.hours
      "an hour ago"
    when 2.hours..1.day
      "#{diff.hours} hours ago"
    when 1.day..2.days
      "a day ago"
    when 2.days..1.week
      "#{diff.days} days ago"
    when 1.week..2.weeks
      "a week ago"
    when 2.weeks..4.weeks
      "#{diff.total_weeks.to_i} weeks ago"
    when 4.weeks..8.weeks
      "a month ago"
    when 8.weeks..52.weeks
      "#{(diff.total_weeks.to_i / 4)} months ago"
    when 52.weeks..104.weeks
      "a year ago"
    else
      "#{(diff.total_weeks.to_i / (4 * 12))} years ago"
    end
  end
end
