class OAuthController < ApplicationController
  def new
    redirect_to oauth(find_provider).authorize_uri
  end

  def authenticate
    case provider = find_provider
    when "github"
      sign_in_user "github"
      redirect_to "/announcements/new"
    when "twitter"
      save_user_handle "twitter"
      redirect_to "/me"
    else
      redirect_to "/"
    end
  end

  private def sign_in_user(provider)
    u = oauth(provider).provider.user(params.to_h)

    user = User.find_by_uid_and_provider(u.uid, provider) || User.new
    user.set_attributes(
      {
        :uid      => u.uid,
        :login    => u.nickname,
        :name     => u.name,
        :provider => provider,
      })

    session["user_id"] = user.id.to_s if user.valid? && user.save
  end

  private def save_user_handle(provider)
    user = current_user!

    u = oauth(provider).provider.user(params.to_h)
    user.handle = u.nickname if u.nickname
    user.save
  end

  private def find_provider
    params["provider"]? || "github"
  end

  private def oauth(provider)
    MultiAuth.make provider, "#{SITE.url}/oauth/#{provider}"
  end
end
