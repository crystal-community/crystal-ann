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
end
