require 'spec_helper'

describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do
    it "should increment the Relationship count" do
    end

    it "should respond with success" do
    end
  end

  describe "destroying a relationship with Ajax" do
    it "should decrement the Relationship count" do
    end

    it "should respond with success" do
    end
  end
end
