require "../spec_helper"
require "../../src/helpers/query_helper"

class DumbController
  include Helpers::QueryHelper
end

describe Helpers::QueryHelper do
  describe "#to_query" do
    it "encodes empty params when query is empty" do
      params = HTTP::Params.parse("").to_h
      expect(DumbController.new.to_query params).to eq ""
    end

    it "encodes params when query is empty" do
      controller = DumbController.new
      params = HTTP::Params.parse("foo=bar&qux=zoo").to_h
      expect(controller.to_query params).to eq "foo=bar&qux=zoo"
    end

    it "encodes params and query" do
      controller = DumbController.new
      params = HTTP::Params.parse("foo=bar&qux=zoo").to_h
      expect(controller.to_query params, page: 22).to eq "foo=bar&qux=zoo&page=22"
    end

    it "encodes params and query and overrides params values" do
      controller = DumbController.new
      params = HTTP::Params.parse("foo=bar&qux=zoo&page=1").to_h
      expect(controller.to_query params, page: 22).to eq "foo=bar&qux=zoo&page=22"
    end

    it "encodes only query when params are empty" do
      controller = DumbController.new
      params = HTTP::Params.parse("").to_h
      expect(controller.to_query params, page: 22, foo: "bar").to eq "page=22&foo=bar"
    end
  end
end
