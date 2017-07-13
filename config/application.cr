require "amber"
require "yaml"
require "sidekiq"
require "multi_auth"
require "option_parser"

AMBER_PORT = ENV["PORT"]? || 3008
AMBER_ENV  = ENV["AMBER_ENV"]? || "development"

SITE = YAML.parse(File.read "config/site.yml")[AMBER_ENV]
Sidekiq::Client.default_context = Sidekiq::Client::Context.new
MultiAuth.config("github", ENV.fetch("GITHUB_ID", ""), ENV.fetch("GITHUB_SECRET", ""))

Amber::Server.instance.config do |app|
  app_path = __FILE__
  app.name = "Crystal [ANN] web application."
  app.port = AMBER_PORT.to_i
  app.env = AMBER_ENV.to_s
  app.log = ::Logger.new(STDOUT)
  app.log.level = ::Logger::INFO
end
