require "yaml"

struct SiteSettings
  getter name, description, url, force_ssl

  def initialize(@name : String, @description : String, @url : String, @force_ssl : Bool)
  end

  def self.load(env = AMBER_ENV)
    config = YAML.parse(File.read "config/site.yml")[env]

    SiteSettings.new config["name"].as_s,
      config["description"].as_s,
      config["url"].as_s,
      config["force_ssl"] == "true"
  end
end

SITE = SiteSettings.load
