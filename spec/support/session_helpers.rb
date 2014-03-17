module SessionHelpers

  def sign_in(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"

    # Sign in when not using Capybara as well
    cookies[:remember_token] = user.remember_token
  end

  def valid_user_data(user)
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Confirmation", with: user.password_confirmation
  end

end
