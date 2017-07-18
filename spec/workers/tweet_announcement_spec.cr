require "../spec_helper"

describe Workers::TweetAnnouncement do
  worker = Workers::TweetAnnouncement.new
  announcement = Announcement.new({
    :id          => 1_i64,
    :title       => "First Announcement",
    :description => "Super cool stuff created",
  })

  describe "#tweet_template" do
    it "includes announcement title" do
      worker.tweet_template(announcement)
            .includes?(announcement.title.to_s).should eq true
    end

    it "includes SITE.url" do
      worker.tweet_template(announcement)
            .includes?(SITE.url).should eq true
    end

    it "includes announcement.short_path" do
      worker.tweet_template(announcement)
            .includes?(announcement.short_path.to_s).should eq true
    end

    it "includes #crystallang hashtag" do
      worker.tweet_template(announcement)
            .includes?("#crystallang").should eq true
    end
  end
end
