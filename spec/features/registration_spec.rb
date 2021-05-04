# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', "
  In order to ask questions
  As an unregistred user
  I'd like to be able to register
" do
  background { visit new_user_registration_path }
  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    open_email('user@test.com')
    current_email.click_on 'Confirm my account'

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to register with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  describe 'Register with Omniauth services' do
    describe 'GitHub' do
      scenario 'with correct data' do
        mock_auth_hash('github', email: 'test@test.ru')
        visit new_user_registration_path
        click_link "Sign in with GitHub"

        expect(page).to have_content 'You have to confirm your email address before continuing.'
      end

      scenario "can handle authentication error with GitHub" do
        invalid_mock('github')
        visit new_user_registration_path
        click_link "Sign in with GitHub"
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end

    describe 'Vkontakte' do
      scenario "with correct data, without email" do
        mock_auth_hash('vkontakte', email: nil)
        visit new_user_registration_path
        click_link "Sign in with Vkontakte"
        fill_in 'user_email', with: 'tests@test.ru'
        click_on 'Confirm email'

        open_email('tests@test.ru')
        current_email.click_link 'Confirm my account'
        click_link "Sign in with Vkontakte"

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario "can handle authentication error with Vkontakte" do
        invalid_mock('vkontakte')
        visit new_user_registration_path
        click_link "Sign in with Vkontakte"

        expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      end
    end
  end
end
