require "yaml"

struct SiteSettings
  getter name, description, url

  def initialize(@name : String, @description : String, @url : String)
  end

  def self.load(env = AMBER_ENV)
    config = YAML.parse(File.read "config/site.yml")[AMBER_ENV]

    SiteSettings.new config["name"].as_s,
      config["description"].as_s,
      config["url"].as_s
  end
end

SITE = SiteSettings.load
