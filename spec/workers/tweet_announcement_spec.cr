require "../spec_helper"
require "webmock"
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

  describe "#tweet" do
    let(:update_response) do
      {
        id:            1,
        retweet_count: 0,
        favorited:     false,
        truncated:     false,
        retweeted:     false,
        source:        "Crystal ANN",
        created_at:    "Wed Sep 05 00:37:15 +0000 2012",
        text:          "",
      }
    end

    let!(:stub_statuses_update) do
      WebMock.stub(:post, "https://api.twitter.com/1.1/statuses/update.json")
             .to_return(body: update_response.to_json)
    end

    it "makes a tweet" do
      expect(subject.tweet(announcement)).not_to eq false
    end
  end
end
