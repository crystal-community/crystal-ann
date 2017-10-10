require "./spec_helper"
require "webmock"

describe OAuthController do
  describe "GET authenticate" do
    context "when provider is not known" do
      it "redirects to /" do
        get "/oauth/facebook"
        expect(response).to redirect_to "/"
      end
    end
  end

  context "Github" do
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

    describe "GET authenticate" do
      before { Announcement.clear; User.clear }
      before { stub_github_authorize_request }

      it "creates a new user" do
        get "/oauth/github", body: "code=#{code}"
        u = User.find_by_uid_and_provider(github_user_response[:id], "github")
        expect(u).not_to be_nil
        expect(u.not_nil!.login).to eq github_user_response[:login]
        expect(u.not_nil!.name).to eq github_user_response[:name]
      end

      it "signs in a user" do
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
        u = user(
          name: "Marilyn Manson",
          login: github_user_response[:login],
          uid: github_user_response[:id].to_s,
          provider: "github"
        ).tap(&.save).not_nil!

        get "/oauth/github", body: "code=#{code}"
        user = User.find(u.id)
        expect(user.not_nil!.name).to eq github_user_response[:name]
      end

      it "does not create a new user if such user exists" do
        u = user(
          name: "Marilyn Manson",
          login: github_user_response[:login],
          uid: github_user_response[:id].to_s,
          provider: "github"
        ).tap(&.save).not_nil!

        get "/oauth/github", body: "code=#{code}"
        expect(User.all.size).to eq 1
      end
    end
  end

  context "Twitter" do
    let(:user) { user(login: "JohnDoe").tap &.save }
    let(:twitter_consumer_key) { "consumer_key" }
    let(:twitter_consumer_secret) { "consumer_secret_key" }
    let(:twitter_access_token_response) do
      {
        oauth_token:              "NPcudxy0yU5T3tBzho7iCotZ3cnetKwcTIRlX0iwRl0",
        oauth_token_secret:       "veNRnAWe6inFuo8o2u8SLLZLjolYDmDP7SzL0YfYI",
        oauth_callback_confirmed: "true",
      }
    end
    let(:twitter_access_token_response) do
      {
        oauth_token:        "7588892-kagSNqWge8gB1WwE3plnFsJHAZVfxWD7Vb57p0b4",
        oauth_token_secret: "PbKfYqSryyeKDWz4ebtY3o5ogNLG11WJuZBc9fQrQo",
      }
    end
    let(:twitter_verify_credentials_response) do
      {
        id:                38895958,
        name:              "Sean Cook",
        screen_name:       "theSeanCook",
        location:          "San Francisco",
        url:               "http://twitter.com",
        description:       "I taught your phone that thing you like.  The Mobile Partner Engineer @Twitter.",
        profile_image_url: "http://a0.twimg.com/profile_images/1751506047/dead_sexy_normal.JPG",
        email:             "me@twitter.com",
      }
    end
    let(:twitter_authenticate_request) do
      {
        oauth_token:    "token",
        oauth_verifier: "verifier",
      }
    end

    let(:stub_twitter_authorize_request) do
      WebMock.stub(:post, "https://api.twitter.com/oauth/request_token")
             .to_return(body: HTTP::Params.encode twitter_access_token_response)
    end
    let(:stub_access_token_request) do
      WebMock.stub(:post, "https://api.twitter.com/oauth/access_token")
             .to_return(body: HTTP::Params.encode twitter_access_token_response)
    end
    let(:stub_twitter_verify_credentials_request) do
      WebMock.stub(:get, "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true")
             .to_return(body: twitter_verify_credentials_response.to_json)
    end

    before do
      MultiAuth.config "twitter", twitter_consumer_key, twitter_consumer_secret
    end

    describe "GET new" do
      before { stub_twitter_authorize_request }

      it "redirects to twitter authorize uri" do
        get "/oauth/new?provider=twitter"
        location = response.headers["Location"]
        expect(location.includes? "https://api.twitter.com/oauth/authorize").to be_true
      end
    end

    describe "GET authenticate" do
      before { stub_access_token_request }
      before { stub_twitter_verify_credentials_request }
      before { Announcement.clear; User.clear }

      let(:request_body) { HTTP::Params.encode(twitter_authenticate_request) }

      context "when signed in" do
        before { login_as user }

        it "saves a twitter handle" do
          get "/oauth/twitter", body: request_body
          u = User.find(user.id)
          expect(u.try &.handle).to eq twitter_verify_credentials_response[:screen_name]
        end

        it "redirects to /me" do
          get "/oauth/twitter", body: request_body
          expect(response).to redirect_to "/me"
        end
      end

      context "when not signed in" do
        it "redirects to /" do
          get "/oauth/twitter", body: request_body
          expect(response).to redirect_to "/"
        end
      end
    end
  end
end
