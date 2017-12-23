require "./spec_helper"

describe StaticController do
  describe "GET about" do
    it "renders about page" do
      get "/about"
      expect(response.status_code).to eq 200
    end
  end
end
