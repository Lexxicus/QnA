require 'rails_helper'

feature 'User can create an answer to question', %q{
  In order to help user
  As an authenticated user
  I'd like to be able to do answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give answer to question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Send answer'

      expect(page).to have_content 'Your answer added!!'
      expect(page).to have_content 'Answer body'
    end

    scenario 'give answer to question with errors' do
      click_on 'Send answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Send answer'
  end
end
