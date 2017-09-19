require "../spec_helper"
require "../../src/helpers/time_ago_helper"

describe Helpers::TimeAgoHelper do
  describe ".time_ago_in_words" do
    it "transforms time interval into words" do
      expectations = {
        1.second.ago   => "just now",
        15.seconds.ago => "just now",
        60.seconds.ago => "a minute ago",
        1.minute.ago   => "a minute ago",
        2.minutes.ago  => "2 minutes ago",
        59.minutes.ago => "59 minutes ago",
        1.hour.ago     => "an hour ago",
        5.hour.ago     => "5 hours ago",
        24.hours.ago   => "a day ago",
        2.days.ago     => "2 days ago",
        1.week.ago     => "a week ago",
        2.weeks.ago    => "2 weeks ago",
        1.month.ago    => "a month ago",
        6.weeks.ago    => "a month ago",
        2.months.ago   => "2 months ago",
        8.months.ago   => "8 months ago",
        12.months.ago  => "a year ago",
        1.year.ago     => "a year ago",
        18.months.ago  => "a year ago",
        2.years.ago    => "2 years ago",
        26.months.ago  => "2 years ago",
        10.years.ago   => "10 years ago",
      }
      expectations.each do |date, result|
        expect(Helpers::TimeAgoHelper.time_ago_in_words(date)).to eq result
      end
    end
  end
end
