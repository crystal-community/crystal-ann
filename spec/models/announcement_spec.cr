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
      expect(announcement(type: -1_i64).valid?).to be_false
    end
  end

  describe "#typename" do
    it "returns the properly capitalized type name" do
      expect(announcement(type: 0_i64).typename).to eq "Blog post"
      expect(announcement(type: 1_i64).typename).to eq "Project update"
      expect(announcement(type: 2_i64).typename).to eq "Conference"
      expect(announcement(type: 3_i64).typename).to eq "Meetup"
      expect(announcement(type: 4_i64).typename).to eq "Podcast"
      expect(announcement(type: 5_i64).typename).to eq "Screencast"
      expect(announcement(type: 6_i64).typename).to eq "Video"
      expect(announcement(type: 7_i64).typename).to eq "Other"
    end

    it "raises error if type is wrong" do
      raise_error { announcement(type: -1_i64).typename }
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

    it "autolinks" do
      anns = [
        announcement(description: "http://www.myproj.com/"),
        announcement(description: "Some new project at http://www.myproj.com/."),
        announcement(description: "(link: http://www.myproj.com/)."),
        announcement(description: "# Bigger example\nLorem ipsum http://www.myproj.com/."),
      ]
      results = [
        "<p><a href=\"http://www.myproj.com/\">http://www.myproj.com/</a></p>",
        "<p>Some new project at <a href=\"http://www.myproj.com/\">http://www.myproj.com/</a>.</p>",
        "<p>(link: <a href=\"http://www.myproj.com/\">http://www.myproj.com/</a>).</p>",
        "<h1>Bigger example</h1>\n\n<p>Lorem ipsum <a href=\"http://www.myproj.com/\">http://www.myproj.com/</a>.</p>",
      ]
      anns.size.times do |i|
        expect(anns[i].content).to eq(results[i])
      end
    end

    it "autolink/markdown edge cases" do
      content = "<a href=\"hello\">http://example.com</a>"
      expect(announcement(description: content).content)
        .to eq "<p>&lt;a href=\"hello\"><a href=\"http://example.com\">http://example.com</a>&lt;/a></p>"

      content = "<a href=\"http://www.myblog.com\">http://www.myblog.com</a>"
      expect(announcement(description: content).content)
        .to eq "<p>&lt;a href=\"http://www.myblog.com\">http://www.myblog.com&lt;/a></p>"
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

  describe ".random" do
    let!(:ann) { announcement(user.tap &.save).tap &.save }

    before do
      Announcement.clear
      User.clear
    end

    it "returns random announcements" do
      expect(Announcement.random.not_nil!.id).to eq ann.id
    end
  end
end
