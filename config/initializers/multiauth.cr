require "multi_auth"

MultiAuth.config("github", ENV.fetch("GITHUB_ID", ""), ENV.fetch("GITHUB_SECRET", ""))
MultiAuth.config("twitter", ENV.fetch("TWITTER_CONSUMER_KEY", ""), ENV.fetch("TWITTER_CONSUMER_SECRET", ""))
