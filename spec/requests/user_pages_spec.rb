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

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: "Sign Up") }

        it { should have_error_message("Password can't be blank") }
        it { should have_error_message("Name can't be blank") }
        it { should have_error_message("Email can't be blank") }
        it { should have_error_message("Email is invalid") }
        it { should have_error_message("Password is too short (minimum is 6 characters)") }
        it { should have_error_message("Password confirmation can't be blank") }
      end
    end

    describe "with valid data" do
      let(:user) { FactoryGirl.build(:user) }
      before { valid_user_data(user) }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('title', text: user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
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
