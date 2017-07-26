class StaticController < ApplicationController
  def about
    render("about.slang")
  end

  def index
    "404 - Page not found"
  end
end
