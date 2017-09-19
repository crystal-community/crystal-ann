require "sidekiq"
require "twitter-crystal"
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
          ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end

    def tweet(announcement)
      logger.info "Tweeting Announcement ##{announcement.id}"
      status = tweet_template announcement
      twitter_client.update(status)
    rescue e
      logger.error "Unable to tweet Announcement ##{announcement.id} (#{status})"
      logger.error "Reason: #{e.message}"
    end

    def tweet_template(announcement)
      "#{announcement.title} #{SITE.url}#{announcement.short_path} #crystallang"
    end
  end
end
