require 'rails_helper'

feature 'Author of question can choose the best answer', "
  In order to check an answer with solution of problem
  As an question author
  I'd like to be able to choose best answer
" do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answers) { create_list(:answer, 2, question: question, user: users.first) }
  let(:best_answer) { page.find(:css, '.best_answer') }

  describe 'Author of question' do
    background do
      sign_in(users.first)
      visit question_path(question)
    end
    scenario 'chooses the best answer', js: true do
      click_on(id: "best_#{answers.first.id}")

      expect(page).to have_css('.best_answer')
      expect(best_answer).to have_content answers.first.body
    end

    scenario 'chooses the another one best answer', js: true do
      click_on(id: "best_#{answers.second.id}")

      expect(best_answer).to have_content answers.second.body
    end
  end

  describe 'Nonauthor' do
    scenario 'tries mark the best answer for not his question' do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answers.first.id}")
    end

    scenario 'Unauthenticated user tries to mark the best answer' do
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answers.first.id}")
    end
  end
end
