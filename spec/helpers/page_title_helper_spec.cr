require "../spec_helper"
require "../../src/helpers/page_title_helper"

class DumbController
  include Helpers::PageTitleHelper
end

describe Helpers::PageTitleHelper do
  describe "#page_title" do
    it "sets page title" do
      controller = DumbController.new
      controller.page_title "my page title"
      controller.page_title.should eq "my page title - #{SITE.name}"
    end

    it "returns default site title with suffix" do
      DumbController.new.page_title.should eq "#{SITE.description} - #{SITE.name}"
    end
  end
end
