require "amber"
require "../src/controllers/**"
require "../src/mailers/**"
require "../src/models/**"
require "../src/views/**"
require "../src/models/**"
require "../config/*"
require "./seeds/*"

ENV["AMBER_ENV"] = "development"

puts "Preparing development database:"

puts "  * Deleting existed Announcements"
Announcement.clear

puts "  * Creating Announcements"
Seeds::Announcements.create_records

puts "Done."
