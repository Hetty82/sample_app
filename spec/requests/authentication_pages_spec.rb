require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('title', text: 'Sign in') }
    it { should have_selector('h1', text: 'Sign in') }
  end

  describe "signin" do
    it { should_not have_link('Users', href: users_path) }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
    it { should_not have_link('Sign out', href: signout_path) }

    describe "with invalid data" do
      before { visit signin_path }
      before { click_button "Sign in" }

      it { should have_selector('title', text: "Sign in") }
      it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid data" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by a signout" do
        before { click_link "Sign out" }
        it { should have_link("Sign in") }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the UsersController" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { should have_selector('title', text: "Sign in") }
          it { should have_notice('Please sign in') }
        end

        describe "submitting a PUT request to the update action" do
          before { put user_path(user) }

          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the users index" do
          before { visit users_path }

          it { should have_selector('title', text: "Sign in") }
          it { should have_notice('Please sign in') }
        end
      end

      describe "in the MicropostsController" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: "Edit user")
          end

          describe "when signing in again" do
            before { sign_in user }

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name)
            end
          end
        end
      end
    end

    describe "as a wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }

        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }

        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as a non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }

        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as an admin" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submitting a DELETE request to delete their own account" do
        before { delete user_path(admin) }

        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as a signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "submitting a GET request to the Users#new action" do
        before { get new_user_path }

        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a POST request to the Users#create action" do
        before { post users_path }

        specify { response.should redirect_to(root_path) }
      end
    end
  end

end
