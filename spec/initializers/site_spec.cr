require "../spec_helper"

describe SiteSettings do
  it "loads SITE settings" do
    SITE.should_not eq nil
  end

  it "loads SITE.name" do
    SITE.name.blank?.should eq false
  end

  it "loads SITE.description" do
    SITE.description.blank?.should eq false
  end

  it "loads SITE.url" do
    SITE.url.blank?.should eq false
  end

  %w(development staging production).each do |env|
    site = SiteSettings.load env

    it "has name in #{env} environment" do
      site.name.blank?.should eq false
    end

    it "has description in #{env} environment" do
      site.description.blank?.should eq false
    end

    it "has url in #{env} environment" do
      site.url.blank?.should eq false
    end
  end
end
