require "amber"
require "../config/application"
require "../src/models/**"
require "./seeds/*"

puts "Preparing development database:"

puts "  * Deleting existing records"
Announcement.clear
User.clear

puts "  * Creating Users"
Seeds::Users.create_records

puts "  * Creating Announcements"
Seeds::Announcements.create_records

puts "Done."
