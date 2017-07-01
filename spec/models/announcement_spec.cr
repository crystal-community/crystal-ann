require "./spec_helper"
require "../../src/models/announcement.cr"

def announcement(**params)
  attributes = {
    :title       => "title",
    :description => "description",
    :type        => Announcement::TYPES.keys.first,
  }.merge!(params.to_h)

  Announcement.new attributes
end

describe Announcement do
  describe "Validation" do
    it "succeeds on valid parameters" do
      announcement(title: "test title").valid?.should eq true
    end

    it "requires title" do
      announcement(title: "").valid?.should eq false
    end

    it "validates minimum size of title" do
      announcement(title: "-" * 3).valid?.should eq false
    end

    it "validates maximum size of title" do
      announcement(title: "-" * 101).valid?.should eq false
    end

    it "requires description" do
      announcement(description: "").valid?.should eq false
    end

    it "validates minimum size of description" do
      announcement(description: "-" * 3).valid?.should eq false
    end

    it "validates maximum size of description" do
      announcement(description: "-" * 4001).valid?.should eq false
    end

    it "validates type" do
      announcement(type: -1).valid?.should eq false
    end
  end

  describe "#typename" do
    it "returns the name of the type" do
      Announcement::TYPES.each do |type, name|
        announcement(type: type).typename.should eq name
      end
    end

    it "raises error if type if wrong" do
      expect_raises { announcement(type: -1).typename }
    end
  end

  describe "#content" do
    it "returns html content" do
      announcement(description: "test").content.should eq "<p>test</p>"
    end
  end
end
