require "./spec_helper"

describe UserController do
  let(:user) { user(login: "UserControllerTest").tap &.save }

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
end
