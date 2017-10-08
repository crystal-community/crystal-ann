require "./spec_helper"

describe SessionsController do
  describe "DELETE destroy" do
    let(:user) { user(login: "Bro").tap &.save }
    before { login_as user }

    it "signs out user" do
      delete "/sessions"
      expect(session["user_id"]).to be_nil
    end

    it "does not sign out user if csrf is invalid" do
      delete "/sessions", body: "_csrf=invalid-token"
      expect(response.status_code).to eq 403
      expect(session["user_id"]).not_to be_nil
    end

    it "redirects to root url" do
      delete "/sessions"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/"
    end
  end
end
