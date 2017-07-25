require "./spec_helper"
require "../../src/models/announcement.cr"

describe Announcement do
  describe "Validation" do
    it "succeeds on valid parameters" do
      expect(announcement.valid?).to be_true
    end

    it "requires title" do
      expect(announcement(title: "").valid?).to be_false
    end

    it "validates minimum size of title" do
      expect(announcement(title: "-" * 3).valid?).to be_false
    end

    it "validates maximum size of title" do
      expect(announcement(title: "-" * 101).valid?).to be_false
    end

    it "requires description" do
      expect(announcement(description: "").valid?).to be_false
    end

    it "validates minimum size of description" do
      expect(announcement(description: "-" * 3).valid?).to be_false
    end

    it "validates maximum size of description" do
      expect(announcement(description: "-" * 4001).valid?).to be_false
    end

    it "validates type" do
      expect(announcement(type: -1).valid?).to be_false
    end
  end

  describe "#typename" do
    it "returns the properly capitalized type name" do
      expect(announcement(type: 0).typename).to eq "Blog Post"
      expect(announcement(type: 1).typename).to eq "Project Update"
      expect(announcement(type: 2).typename).to eq "Conference"
      expect(announcement(type: 3).typename).to eq "Meetup"
      expect(announcement(type: 4).typename).to eq "Podcast"
      expect(announcement(type: 5).typename).to eq "Screencast"
      expect(announcement(type: 6).typename).to eq "Video"
      expect(announcement(type: 7).typename).to eq "Other"
    end

    it "raises error if type is wrong" do
      raise_error { announcement(type: -1).typename }
    end
  end

  describe "#content" do
    it "returns html content" do
      expect(announcement(description: "test").content).to eq "<p>test</p>"
    end

    it "encodes html tags" do
      ann = announcement(description: "<script>console.log('hello')</script>")
      expect(ann.content).to eq "<p>&lt;script>console.log('hello')&lt;/script></p>"
    end
  end

  describe "#short_path" do
    it "returns short path to the announcement" do
      expect(announcement.tap { |a| a.id = 1_i64 }.short_path).to eq "/=D49Nz"
    end

    it "returns nil if announcement does not have id" do
      expect(announcement.short_path).to eq nil
    end
  end

  describe "#hashid" do
    it "returns nil if id is not present" do
      expect(announcement.hashid).to eq nil
    end

    it "returns hash id if id is present" do
      hashid = announcement.tap { |a| a.id = 1_i64 }.hashid
      expect(hashid).to eq "D49Nz"
    end
  end
end
