Amber::Server.configure do |app|
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::Logger.new unless app.env == "test"
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CSRF.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::Static.new("./public")
    plug HTTP::CompressHandler.new
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", StaticController, :index
    get "/about", StaticController, :about
  end

  routes :web do
    resources "/announcements", AnnouncementController
    get "/=:hashid", AnnouncementController, :expand
    get "/rss", RSSController, :show
    get "/sessions/new", SessionsController, :new
    delete "/sessions", SessionsController, :destroy
    get "/github/auth", SessionsController, :create
    get "/me", UserController, :me
    get "/users/:login", UserController, :show
    get "/", AnnouncementController, :index
  end
end
