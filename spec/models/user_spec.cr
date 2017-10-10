require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  describe "Validation" do
    it "succeeds on valid parameters" do
      expect(user.valid?).to be_true
    end

    it "requires login not to be blank" do
      expect(user(login: "").valid?).to be_false
    end

    it "requires uid not to be blank" do
      expect(user(uid: "").valid?).to be_false
    end

    it "requires provider not to be blank" do
      expect(user(provider: "").valid?).to be_false
    end

    it "allows role to be blank" do
      expect(user(role: "").valid?).to be_true
    end

    it "allows handle to be blank" do
      expect(user(handle: "").valid?).to be_true
    end
  end

  describe "#admin?" do
    it "returns false if roles does not equal to admin" do
      expect(user(role: "user").admin?).to be_false
    end

    it "returns true if roles equals to admin" do
      expect(user(role: "admin").admin?).to be_true
    end

    it "returns false if roles is not specified" do
      expect(user.admin?).to be_false
    end
  end

  describe "#can_update?" do
    it "returns true if announcement belongs to the user" do
      user = user().tap { |u| u.id = 1_i64 }
      announcement = announcement(user_id: user.id.not_nil!)
      expect(user.can_update? announcement).to be_true
    end

    it "returns false if announcement does not belong to the user" do
      announcement = announcement(user_id: 2_i64)
      expect(user.can_update? announcement).to be_false
    end

    it "returns true if user is admin and announcement does not belong to the user" do
      announcement = announcement(user_id: 2_i64)
      expect(user(role: "admin").can_update? announcement).to be_true
    end
  end

  describe "#me?" do
    it "returns true if this is the same user" do
      user = user().tap { |u| u.id = 1_i64 }
      expect(user.me? user).to be_true
    end

    it "returns false if this is not the same user" do
      user = user().tap { |u| u.id = 1_i64 }
      expect(user.me? user()).to be_false
    end
  end

  describe "#avatar_url" do
    it "returns url to user's avatar" do
      expect(user.avatar_url).not_to be_nil
    end
  end

  describe "#github_url" do
    it "returns url to user's github profile" do
      expect(user.github_url).not_to be_nil
    end
  end

  describe "#twitter_url" do
    it "returns nil if user does not have a handle" do
      expect(user.twitter_url).to be_nil
    end

    it "returns url if user has a handle" do
      expect(user(handle: "crystal-ann").twitter_url).not_to be_nil
    end
  end

  describe "#total_announcements" do
    before do
      Announcement.clear
      User.clear
    end

    let(:user) { user(login: "john").tap &.save }

    it "returns number of announcements that belong to user" do
      an = announcement(user: user).tap &.save
      expect(user.total_announcements).to eq 1
    end

    it "returns 0 if there are no announcements that belong to user" do
      expect(user.total_announcements).to eq 0
    end
  end

  describe "#find_by_login" do
    before do
      Announcement.clear
      User.clear
    end

    let(:user) { user(login: "john").tap &.save }

    it "can find user by it's login" do
      expect(User.find_by_login(user.login)).not_to be_nil
    end

    it "returns nil if such user does not exist" do
      expect(User.find_by_login("bad-login")).to be_nil
    end
  end
end
