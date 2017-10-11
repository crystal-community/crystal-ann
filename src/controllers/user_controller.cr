class UserController < ApplicationController
  def show
    if user = User.find_by_login params["login"]
      render "show.slang"
    else
      redirect_to "/"
    end
  end

  def me
    if user = current_user
      render "show.slang"
    else
      redirect_to "/"
    end
  end

  def remove_handle
    if user = current_user
      user.handle = nil
      user.save
      redirect_to "/me"
    else
      redirect_to "/"
    end
  end
end
