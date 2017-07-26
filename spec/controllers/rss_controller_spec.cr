require "./spec_helper"

describe RSSController do
  let(:count) { 5 }
  let(:title) { "Crystal released: 1.0." }
  let(:user) { user(login: "crystal-lang").tap &.save }

  it "returns application/xml header" do
    get "/rss"
    expect(response.headers["Content-Type"]?).to eq "application/xml"
  end

  describe "GET show" do
    context "when there are announcements available" do
      it "returns newest announcements" do
        count.times { |i| announcement(user, title: title + i.to_s).tap &.save }
        get "/rss"
        count.times { |i| expect(response.body.includes? title + i.to_s).to be_true }
      end
    end

    context "when there no announcements available" do
      it "renders show template" do
        get "/rss"
        expect(response.status_code).to eq 200
      end
    end
  end
end
