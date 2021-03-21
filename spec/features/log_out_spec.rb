require 'rails_helper'

feature 'User can log out', "
  In order to log out
  As an authenticate user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }
  scenario 'Registered user tries to log out' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
