require "../spec_helper"

describe SiteSettings do
  it "loads SITE settings" do
    expect(SITE).not_to be_nil
  end

  it "loads SITE.name" do
    expect(SITE.name.blank?).to be_false
  end

  it "loads SITE.description" do
    expect(SITE.description.blank?).to be_false
  end

  it "loads SITE.url" do
    expect(SITE.url.blank?).to be_false
  end

  {% for env in %w(test development staging production) %}
    let(:site) { SiteSettings.load {{env}} }

    it "has name in {{env.id}} environment" do
      expect(site.name.blank?).to be_false
    end

    it "has description in {{env.id}} environment" do
      expect(site.description.blank?).to be_false
    end

    it "has url in {{env.id}} environment" do
      expect(site.url.blank?).to be_false
    end
  {% end %}
end
