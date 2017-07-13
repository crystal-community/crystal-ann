require "sidekiq"
require "twitter"
require "../models/announcement"

module Workers
  class TweetAnnouncement
    include Sidekiq::Worker

    def perform(id : Int64)
      if announcement = Announcement.find(id)
        tweet(announcement)
      end
    end

    def twitter_client
      @twitter_client ||=
        Twitter::REST::Client.new ENV["TWITTER_CONSUMER_KEY"],
          ENV["TWITTER_CONSUMER_SECRET"],
          ENV["TWITTER_ACCESS_TOKEN"],
          ENV["TWITTER_TOKEN_SECRET"]
    end

    def tweet(announcement)
      logger.error "Tweeting Announcement ##{announcement.id}"
      status = tweet_template announcement
      twitter_client.post("/1.1/statuses/update.json", {"status" => status})
    rescue e
      logger.error "Unable to tweet Announcement ##{announcement.id} (#{status})"
      logger.error "Reason: #{e.message}"
    end

    def tweet_template(announcement)
      site_url = SITE["url"]
      "#{announcement.title} #{site_url}#{announcement.path} #crystallang"
    end
  end
end
