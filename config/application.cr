require "option_parser"

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "") do |opt_port|
  end
end

AMBER_ENV = ENV["AMBER_ENV"]? || "development"

Amber::Server.instance.config do |app|
  app_path = __FILE__
  app.name = "Crystal [ANN] web application."
  app.port = (ENV["PORT"]? || "3008").to_i
  app.env = AMBER_ENV.to_s
  app.log = ::Logger.new(STDOUT)
  app.log.level = ::Logger::INFO
end

require "yaml"
SITE = YAML.parse(File.read "config/site.yml")[AMBER_ENV]

require "multi_auth"
MultiAuth.config("github", ENV.fetch("GITHUB_ID", ""), ENV.fetch("GITHUB_SECRET", ""))

require "micrate"
require "pg"
if AMBER_ENV != "development"
  puts "Migrating data"
  Micrate::DB.connection_url = ENV["DATABASE_URL"]?
  Micrate::Cli.run_up
  puts "Migration finished"
end
