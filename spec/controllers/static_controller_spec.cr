require "./spec_helper"

describe StaticController do
  describe "GET about" do
    it "renders about page" do
      get "/about"
      expect(response.status_code).to eq 200
    end
  end

  describe "GET index" do
    it "returns 404 not found" do
      get "/index"
      expect(response.status_code).to eq 200
      expect(response.body).to eq "404 - Page not found"
    end

    it "returns 404 not found for any unknown request" do
      get "/blah-no-exists"
      expect(response.body).to eq "404 - Page not found"
    end
  end
end
