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
        it { should have_error_message("Password is too short") }
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('title', text: "Edit user") }
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_link('change photo', href: "http://gravatar.com/emails") }
    end

    describe "with invalid data" do
      before { click_button "Save changes" }

      it { should have_error_message("Password is too short") }
      it { should have_error_message("Password confirmation can't be blank") }
    end

    describe "with valid data" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_success_message("Your profile is updated") }
      it { should have_link('Sign out', href: signout_path) }

      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }

    end
  end

end
