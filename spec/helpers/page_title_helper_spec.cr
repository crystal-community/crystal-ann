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
      expect(controller.page_title).to eq "my page title - #{SITE.name}"
    end

    it "returns default site title with suffix" do
      expect(DumbController.new.page_title).to eq "#{SITE.description} - #{SITE.name}"
    end
  end
end
