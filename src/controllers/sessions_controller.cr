class SessionsController < ApplicationController
  def new
    redirect_to oauth(find_provider).authorize_uri
  end

  def create
    provider = find_provider
    u = oauth(provider).provider.user(params.to_h)

    user = User.find_by_uid_and_provider(u.uid, provider) || User.new
    user.set_attributes({
      :uid      => u.uid,
      :login    => u.nickname,
      :name     => u.name,
      :provider => provider,
    })

    session["user_id"] = user.id.to_s if user.valid? && user.save
    redirect_to "/announcements/new"
  end

  private def oauth(provider)
    hosturl = SITE["url"]
    MultiAuth.make provider, "#{hosturl}/#{provider}/auth"
  end

  private def find_provider
    params["provider"]? || "github"
  end
end
