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

  describe "micropost desctruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before  { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "delete links" do
    let!(:micropost1) { FactoryGirl.create(:micropost, user: user) }
    let!(:micropost2) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
    before { visit root_path }

    it { should have_link("delete", href: micropost_path(micropost1)) }
    it { should_not have_link("delete", href: micropost_path(micropost2)) }
  end

  describe "pagination" do
    let!(:first_on_next_page) do
      FactoryGirl.create(:micropost, user: user, content: 'I am on page 2')
    end
    let!(:first_10) { 10.times.map { FactoryGirl.create(:micropost, user: user) } }
    before { visit root_path }

    it { should have_selector('.pagination') }

    it "should list the first ten micropost" do
      first_10.each do |micropost|
        page.should have_selector("##{dom_id(micropost)}")
      end
      page.should have_no_selector("##{dom_id(first_on_next_page)}")
    end
  end

end
