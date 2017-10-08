require "./spec_helper"
require "webmock"

describe OAuthController do
  let(:code) { "5ca3797f33399346a01c" }
  let(:github_id) { "roCDAM4ShR" }
  let(:github_secret) { "J9SYlLlO6XIk5lBqtOpoQlOhcbVEqbm5" }
  let(:github_access_token_response) do
    {
      access_token:  "iuxcxlkbwe2342lkasdfjk2klsdj",
      token_type:    "Bearer",
      expires_in:    300,
      refresh_token: nil,
      scope:         "user",
    }
  end
  let(:github_user_response) do
    {
      login: "amber",
      id:    36345345,
      name:  "Amber Framework",
      email: "test@email.com",
      bio:   "Blah",
    }
  end

  let(:stub_github_authorize_request) do
    MultiAuth.config "github", github_id, github_secret

    body = "client_id=#{github_id}&client_secret=#{github_secret}&redirect_uri=&grant_type=authorization_code&code=#{code}"
    headers = {"Accept" => "application/json", "Content-type" => "application/x-www-form-urlencoded"}
    WebMock.stub(:post, "https://github.com/login/oauth/access_token")
           .with(body: body, headers: headers)
           .to_return(body: github_access_token_response.to_json)

    WebMock.stub(:get, "https://api.github.com/user").to_return(body: github_user_response.to_json)
  end

  describe "GET new" do
    it "redirects to github authorize uri" do
      get "/oauth/new"
      expect(response.headers["Location"].includes? "https://github.com/login/oauth/authorize").to be_true
    end
  end

  describe "GET create" do
    before { Announcement.clear; User.clear }
    before { stub_github_authorize_request }

    it "creates new user" do
      get "/oauth/github", body: "code=#{code}"
      u = User.find_by_uid_and_provider(github_user_response[:id], "github")
      expect(u).not_to be_nil
      expect(u.not_nil!.login).to eq github_user_response[:login]
      expect(u.not_nil!.name).to eq github_user_response[:name]
    end

    it "signs in user" do
      get "/oauth/github", body: "code=#{code}"
      u = User.find_by_uid_and_provider(github_user_response[:id], "github")
      expect(session["user_id"]).to eq u.not_nil!.id.to_s
    end

    it "redirects to announcements#new" do
      get "/oauth/github", body: "code=#{code}"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/announcements/new"
    end

    it "can find existed user and update attributes" do
      u = user(name: "Marilyn Manson",
        login: github_user_response[:login],
        uid: github_user_response[:id].to_s,
        provider: "github").tap(&.save).not_nil!

      get "/oauth/github", body: "code=#{code}"
      user = User.find(u.id)
      expect(user.not_nil!.name).to eq github_user_response[:name]
    end

    it "does not create new user if such user exists" do
      u = user(name: "Marilyn Manson",
        login: github_user_response[:login],
        uid: github_user_response[:id].to_s,
        provider: "github").tap(&.save).not_nil!

      get "/oauth/github", body: "code=#{code}"
      expect(User.all.size).to eq 1
    end
  end
end
