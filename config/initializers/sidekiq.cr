require "sidekiq"

Sidekiq::Client.default_context = Sidekiq::Client::Context.new
