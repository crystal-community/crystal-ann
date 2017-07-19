require "hashids"

HASHIDS = Hashids.new(salt: ENV["HASHIDS_SALT"]? || "crystal-ann-dev", min_length: 5)
