require 'rails_helper'

feature 'User can subscribe/unsubscribe on the question', "
  In order to get notification when created new answers for question
  As an authenticated user
  I'd like to be able to subscribe/unsubscribe to question
" do
  given(:user)       { create(:user) }
  given!(:question)  { create(:question) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribe to question' do
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribe from question' do
      click_on 'Subscribe'

      click_on 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated user', js: true do
    before do
      visit question_path(question)
    end

    scenario 'cant subscribe on question' do
      expect(page).to_not have_css '.subscription'
      expect(page).to_not have_link 'Subscribe'
    end
  end
end
