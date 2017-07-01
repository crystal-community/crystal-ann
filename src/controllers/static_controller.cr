class StaticController < ApplicationController
  def about
    render("about.slang")
  end

  def index
    "do nothing"
  end
end
