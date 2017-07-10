class SessionsController < ApplicationController
  def new
    redirect_to github_oauth.authorize_uri
  end

  def create
    u = github_oauth.provider.user(params.to_h)

    user = User.find_by(:uid, u.uid) || User.new
    user.set_attributes({:uid => u.uid, :name => u.name, :provider => "github"})

    session["user_id"] = user.id.to_s if user.save
    redirect_to "/announcements/new"
  end

  private def github_oauth
    MultiAuth.make "github", "https://2f880ffc.ngrok.io/github/auth"
  end
end
