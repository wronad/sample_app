require 'spec_helper'

describe "User pages" do

  let(:submit) { "Create my account" }

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
    it { should have_submit_button(submit) }
  end

  describe "signup" do

    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "bad username, email, & password" do
        before { submit_signup(' ', 'user@example..com', 'fooba', 'fooba') }

        it { should have_title('Sign up') }
        it { should have_content('The form contains 3 errors.') }
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Email is invalid') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
      end

      describe "mismatching passwords" do
	before { submit_signup('Dan Wrona', 'djw@1.com', 'passwordOne', 'passwordTwo') }

        it { should have_title('Sign up') }
        it { should have_content('The form contains 1 error.') }
        it { should have_content('Password confirmation doesn\'t match Password') }
      end
    end

    describe "with valid information" do
      before { submit_signup('Example User', 'user@example.com', 'foobar', 'foobar') }

      it "should create a user" do
        expect { change(User, :count).by(1) }
      end

      describe "after saving the user" do
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before { save_user(new_name, new_email, user.password, user.password) }

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
