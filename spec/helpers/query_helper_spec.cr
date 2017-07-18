require "../spec_helper"
require "../helpers/query_helper_spec"

class DumbController
  include Helpers::QueryHelper

  property params = HTTP::Params.new({} of String => Array(String))
end

describe Helpers::QueryHelper do
  describe "#to_query" do
    it "encodes empty params when query is empty" do
      DumbController.new.to_query.should eq ""
    end

    it "encodes params when query is empty" do
      controller = DumbController.new
      controller.params = HTTP::Params.parse "foo=bar&qux=zoo"
      controller.to_query.should eq "foo=bar&qux=zoo"
    end

    it "encodes params and query" do
      controller = DumbController.new
      controller.params = HTTP::Params.parse "foo=bar&qux=zoo"
      controller.to_query(page: 22).should eq "foo=bar&qux=zoo&page=22"
    end

    it "encodes params and query and overrides params values" do
      controller = DumbController.new
      controller.params = HTTP::Params.parse "foo=bar&qux=zoo&page=1"
      controller.to_query(page: 22).should eq "foo=bar&qux=zoo&page=22"
    end

    it "encodes only query when params are empty" do
      controller = DumbController.new
      controller.to_query(page: 22, foo: "bar").should eq "page=22&foo=bar"
    end
  end
end
