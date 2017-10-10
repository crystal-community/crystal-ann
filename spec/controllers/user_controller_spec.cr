require "./spec_helper"

describe UserController do
  let(:user) { user(login: "UserControllerTest").tap &.save }

  before do
    Announcement.clear
    User.clear
  end

  describe "GET #show" do
    it "renders show template if user is found" do
      get "/users/#{user.login}"
      expect(response.status_code).to eq 200
      expect(response.body.includes? user.login.not_nil!).to be_true
    end

    it "redirects to root if user is not found" do
      get "/users/no-such-login"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/"
    end
  end

  describe "GET #me" do
    it "renders user#show template if user is signed in" do
      login_as user
      get "/me"
      expect(response.status_code).to eq 200
      expect(response.body.includes? user.login.not_nil!).to be_true
    end

    it "redirects to root if user is not signed in" do
      get "/me"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/"
    end
  end

  describe "PUT #remove_handle" do
    let(:user) { user(handle: "crystal_ann").tap &.save }

    it "removes user handle if user is signed in" do
      login_as user
      put "/users/remove_handle"
      expect(User.find(user.id).not_nil!.handle).to be_nil
    end

    it "redirects to /me if user is signed in" do
      login_as user
      put "/users/remove_handle"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/me"
    end

    it "redirects to / if user is not signed in" do
      put "/users/remove_handle"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/"
    end
  end
end
