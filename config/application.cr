AMBER_PORT = ENV["PORT"]? || 3008
AMBER_ENV  = ENV["AMBER_ENV"]? || "development"

require "amber"
require "./initializers/*"

Amber::Server.instance.config do |app|
  app_path = __FILE__
  app.name = "Crystal [ANN] web application."
  app.port = AMBER_PORT.to_i
  app.env = AMBER_ENV.to_s
  app.log = ::Logger.new(STDOUT)
  app.log.level = ::Logger::INFO
end

Amber::Server.instance.session = {
  :key     => "crystal.ann.session",
  :store   => :encrypted_cookie,
  :expires => 0,
  :secret  => ENV["AMBER_SESSION_SECRET"]? || "",
}
