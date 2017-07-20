require "../spec_helper"

describe DBSettings do
  {% for env in %w(test development staging production) %}

    it "has database_url in {{env.id}} environment" do
      db = DBSettings.load {{env}}
      expect(db.database_url.blank?).to eq false
    end

  {% end %}
end
