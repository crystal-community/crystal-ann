require "amber"
require "../config/*"
require "./helpers/**"
require "./controllers/**"
require "./mailers/**"
require "./models/**"
require "./views/**"
require "../db/migrate"

Amber::Server.instance.run
