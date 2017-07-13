require "../config/application"
require "./workers/**"
require "sidekiq/cli"

cli = Sidekiq::CLI.new
server = cli.configure { }
cli.run(server)
