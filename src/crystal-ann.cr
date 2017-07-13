require "amber"
require "micrate"
require "pg"
require "./controllers/**"
require "./mailers/**"
require "./models/**"
require "./views/**"
require "../config/*"

if AMBER_ENV != "development"
  puts "Migrating data"
  Micrate::DB.connection_url = ENV["DATABASE_URL"]?
  Micrate::Cli.run_up
  puts "Migration finished"
end

Amber::Server.instance.run
