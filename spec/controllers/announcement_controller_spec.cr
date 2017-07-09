require "./spec_helper"

def create_subject
  subject = Announcement.new
  subject.title = "test"
  subject.save
  subject
end

describe AnnouncementController do
  # Spec.before_each do
  #   Announcement.clear
  # end

  # describe "AnnouncementController::Index" do
  #   it "renders all the announcements" do
  #     subject = create_subject
  #     get "/announcements"
  #     response.body.should contain "test"
  #   end
  # end

  # describe AnnouncementController::Show do
  #   it "renders a single announcement" do
  #     subject = create_subject
  #     get "/announcements/#{subject.id}"
  #     response.body.should contain "test"
  #   end
  # end

  # describe AnnouncementController::New do
  #   it "render new template" do
  #     get "/announcements/new"
  #     response.body.should contain "New Announcement"
  #   end
  # end

  # describe AnnouncementController::Create do
  #   it "creates a announcement" do
  #     post "/announcements", body: "title=testing"
  #     subject_list = Announcement.all
  #     subject_list.size.should eq 1
  #   end
  # end

  # describe AnnouncementController::Edit do
  #   it "renders edit template" do
  #     subject = create_subject
  #     get "/announcements/#{subject.id}/edit"
  #     response.body.should contain "Edit Announcement"
  #   end
  # end

  # describe AnnouncementController::Update do
  #   it "updates a announcement" do
  #     subject = create_subject
  #     patch "/announcements/#{subject.id}", body: "title=test2"
  #     result = Announcement.find(subject.id).not_nil!
  #     result.title.should eq "test2"
  #   end
  # end

  # describe AnnouncementController::Delete do
  #   it "deletes a announcement" do
  #     subject = create_subject
  #     delete "/announcements/#{subject.id}"
  #     result = Announcement.find subject.id
  #     result.should eq nil
  #   end
  # end
end
