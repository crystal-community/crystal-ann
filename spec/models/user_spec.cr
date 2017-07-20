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
end
