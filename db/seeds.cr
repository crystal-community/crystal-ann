require "../config/application"
require "../src/models/**"
require "./seeds/*"

Announcement.clear
User.clear

Seeds::Users.create_records
Seeds::Announcements.create_records
