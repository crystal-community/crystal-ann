require "../config/application"
require "micrate"
require "pg"

if ENV["MICRATE_RUN_UP"]?
  Micrate::DB.connection_url = ENV["DATABASE_URL"]
  Micrate::Cli.setup_logger
  Micrate::Cli.run_up
end
