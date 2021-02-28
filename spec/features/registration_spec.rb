require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions
  As an unregistred user
  I'd like to be able to register
} do
  background { visit new_user_registration_path }
  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to register with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
end
