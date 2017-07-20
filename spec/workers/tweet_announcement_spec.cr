require "../spec_helper"
require "../../src/workers/tweet_announcement"

describe Workers::TweetAnnouncement do
  subject { Workers::TweetAnnouncement.new }
  let(:announcement) {
    Announcement.new({
      :id          => 1_i64,
      :title       => "First Announcement",
      :description => "Super cool stuff created",
    })
  }

  describe "#tweet_template" do
    let(:template) { subject.tweet_template announcement }

    it "includes announcement title" do
      expect(template.includes? announcement.title.to_s).to eq true
    end

    it "includes SITE.url" do
      expect(template.includes? SITE.url).to eq true
    end

    it "includes announcement.short_path" do
      expect(template.includes? announcement.short_path.to_s).to eq true
    end

    it "includes #crystallang hashtag" do
      expect(template.includes? "#crystallang").to eq true
    end
  end
end
