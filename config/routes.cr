Amber::Server.configure do |app|
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    # plug Amber::Pipe::Flash.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CSRF.new
    plug Amber::Pipe::PoweredByAmber.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
    plug HTTP::CompressHandler.new
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
    get "/about", StaticController, :about
  end

  routes :web do
    resources "/announcements", AnnouncementController
    get "/announcements/random", AnnouncementController, :random
    get "/=:hashid", AnnouncementController, :expand
    get "/rss", RSSController, :show

    get "/oauth/new", OAuthController, :new
    get "/oauth/:provider", OAuthController, :authenticate
    delete "/sessions", SessionController, :destroy

    get "/me", UserController, :me
    get "/users/:login", UserController, :show
    put "/users/remove_handle", UserController, :remove_handle

    get "/", AnnouncementController, :index
  end
end
