require "yaml"

struct DBSettings
  getter database_url

  def initialize(@database_url : String)
  end

  def self.load(env = AMBER_ENV)
    config = YAML.parse(File.read "config/database.yml")[env]
    DBSettings.new config["database"].as_s
  end
end

ENV["DATABASE_URL"] ||= DBSettings.load.database_url
