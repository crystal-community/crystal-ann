require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  describe "Validation" do
    it "succeeds on valid parameters" do
      user(login: "john").valid?.should eq true
    end

    it "requires login not to be blank" do
      user(login: "").valid?.should eq false
    end

    it "requires uid not to be blank" do
      user(uid: "").valid?.should eq false
    end

    it "requires provider not to be blank" do
      user(provider: "").valid?.should eq false
    end
  end

  describe "#admin?" do
    it "returns false if roles does not equal to admin" do
      user(role: "user").admin?.should eq false
    end

    it "returns true if roles equals to admin" do
      user(role: "admin").admin?.should eq true
    end

    it "returns false if roles is not specified" do
      user(uid: "123").admin?.should eq false
    end
  end

  describe "#can_update?" do
    it "returns true if announcement belongs to the user" do
      user = user(login: "anny").tap { |u| u.id = 1_i64 }
      announcement = announcement(user_id: user.id.not_nil!)
      user.can_update?(announcement).should eq true
    end

    it "returns false if announcement does not belong to the user" do
      user = user(login: "mike").tap { |u| u.id = 1_i64 }
      announcement = announcement(user_id: 2_i64)
      user.can_update?(announcement).should eq false
    end

    it "returns true if user is admin and announcement does not belong to the user" do
      user = user(role: "admin")
      announcement = announcement(user_id: 2_i64)
      user.can_update?(announcement).should eq true
    end
  end
end
