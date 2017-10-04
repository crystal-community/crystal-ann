require "recommender"
require "sidekiq"
require "../models/announcement"
require "../models/recommendation"

module Workers
  class Recommender
    include Sidekiq::Worker

    def perform
      clear_recommendations
      announcements = Announcement.all
      preprocessed_announcements = announcements.map { |a| "#{a.title} #{a.description}" }
      recommender = ::Recommender::ContentBased.new(preprocessed_announcements)

      signal = Channel(Nil).new

      preprocessed_announcements.each_with_index do |_, i|
        ids = recommender.similar_to(i).first(3)
        ids.each do |j|
          data = {
            :announcement_id => announcements[i].id,
            :recommended_id  => announcements[j].id,
          }
          recommendation = Recommendation.new(data)
          spawn do
            recommendation.save
            signal.send nil
          end
        end
      end

      preprocessed_announcements.size.times { signal.receive }
    end

    private def clear_recommendations
      Recommendation.clear
    end
  end
end
