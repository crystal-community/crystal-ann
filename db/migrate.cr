require "../config/application"
require "micrate"
require "pg"

if AMBER_ENV != "development"
  puts "===> Migrating data"
  Micrate::DB.connection_url = ENV["DATABASE_URL"]?
  Micrate::Cli.run_up
  puts "===> Migration finished"
end
