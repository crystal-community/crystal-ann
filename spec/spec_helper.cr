ENV["AMBER_ENV"] = "test"

require "spec2"
require "amber"
require "../config/application"
require "../db/migrate"
require "./support/*"

include Spec2::GlobalDSL

Sidekiq::Client.default_context.logger.level = ::Logger::UNKNOWN
