include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def submit_signup(name, email, passwd, passwd1)
  fill_in "Name",         with: name
  fill_in "Email",        with: email
  fill_in "Password",     with: passwd
  fill_in "Confirmation", with: passwd1
  click_button submit
end

