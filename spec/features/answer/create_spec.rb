# frozen_string_literal: true

require 'rails_helper'

feature 'User can create an answer to question', "
  In order to help user
  As an authenticated user
  I'd like to be able to do answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give answer to question' do
      fill_in 'Create your answer', with: 'Answer body'
      click_on 'Send answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'give answer to question with errors' do
      click_on 'Send answer'

      expect(page).to have_content "Body can't be blank"
    end

    describe 'multiple sessions' do
      scenario 'all users see new answer in real-time', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('another_user') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Create your answer', with: 'Answer body'
          click_on 'Send answer'
          within '.answers' do
            expect(page).to have_content 'Answer body'
          end
        end

        Capybara.using_session('another_user') do
          expect(page).to have_content 'Answer body'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Send answer'
  end
end
