require "yaml"

struct SiteSettings
  getter title, description, url

  def initialize(@title : String, @description : String, @url : String)
  end

  def self.load
    config = YAML.parse(File.read "config/site.yml")[AMBER_ENV]

    SiteSettings.new config["title"].as_s,
      config["description"].as_s,
      config["url"].as_s
  end
end

SITE = SiteSettings.load
