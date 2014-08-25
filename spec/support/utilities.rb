include ApplicationHelper

def fill_in_email_passwd(email, passwd)
  fill_in "Email",    with: email
  fill_in "Password", with: passwd
end

=begin
def valid_signin(user)
  fill_in_email_passwd(email, passwd)
  click_button "Sign in"
end
=end

def fill_in_user(name, email, passwd, passwd1)
  fill_in "Name",         with: name
  fill_in_email_passwd(email, passwd)
  fill_in "Confirm Password", with: passwd1
end

def submit_signup(name, email, passwd, passwd1)
  fill_in_user(name, email, passwd, passwd1)
  click_button submit
end

def save_user(name, email, passwd, passwd1)
  fill_in_user(name, email, passwd, passwd1)
  click_button "Save changes"
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in_email_passwd(user.email, user.password)
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_submit_button do |value|
  match do |actual|
    actual.should have_selector("input[type=submit][value='#{value}']")
  end
end
