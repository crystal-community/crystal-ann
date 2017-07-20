require "../spec_helper"

describe DBSettings do
  %w(test development staging production).each do |env|
    db = DBSettings.load env

    it "has database_url in #{env} environment" do
      db.database_url.blank?.should eq false
    end
  end
end
