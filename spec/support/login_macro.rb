module LoginMacros
  def login(user, password)
    fill_in 'email', with: user.email
    fill_in 'password', with: password
    click_button 'Login'
  end
end
