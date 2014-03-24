require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid data" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error message" do
        before { click_button "Post"}
        it { should have_error_message("Content can't be blank")}
      end
    end

    describe "with valid data" do
      before { fill_in 'micropost_content', with: "Bla bla bla" }

      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
end