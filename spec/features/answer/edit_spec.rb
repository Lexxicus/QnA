require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user.first) }

  scenario 'Unauthenticated can not adit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author' do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer',	with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer this errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticate user' do
    scenario "tries to edit other user's answers" do
      sign_in(user.last)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
