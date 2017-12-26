AMBER_PORT = ENV["PORT"]? || 3008
AMBER_ENV  = ENV["AMBER_ENV"]? || "development"

require "amber"
require "./initializers/*"

Amber::Server.configure do |settings|
  settings.name = "Crystal [ANN] web application."
  settings.port = AMBER_PORT.to_i
  settings.host = "0.0.0.0"

  settings.session = {
    "key"     => "crystal.ann.session",
    "store"   => "encrypted_cookie",
    "expires" => 0,
    "secret"  => ENV["AMBER_SESSION_SECRET"]? || "",
  }
end
