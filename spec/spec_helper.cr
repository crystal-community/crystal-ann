ENV["AMBER_ENV"] = "test"

require "spec2"
require "amber"
require "../config/application"
require "../db/migrate"

include Spec2::GlobalDSL
