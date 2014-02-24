require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "Signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign Up') }
    it { should have_selector('title', text: full_title('Sign Up')) }

  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account"}

    describe "with invalid data" do
      it "should not create a user" do
        expect { click_button submit }.to_not change(User, :count)
      end

    end

    describe "with valid data" do
      before do
        fill_in "Name", with: "Mickey Mouse"
        fill_in "Email", with: "mickey@mouse.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count)
      end
    end
  end

  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

end
