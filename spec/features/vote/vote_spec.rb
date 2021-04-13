require 'rails_helper'

feature 'User can vote for any answer or question', %q{
  In order to mark question or answer
  As an authenticated user
  I'd like to be able to vote
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: another_user) }
  given(:answer) { create(:answer, question: question, user:another_user) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote up for question', js: true do
      click_on(id: "vote_up_#{question.class.name.downcase}_#{question.id}")
      sleep 1
      expect(question.rating).to eq 1
    end

    scenario 'can vote down for question', js: true do
      click_on(id: "vote_down_#{question.class.name.downcase}_#{question.id}")
      sleep 1
      expect(question.rating).to eq -1
    end

    scenario 'can cancel his vote' do
      question.vote_up(user)
      click_on(id: "vote_up_#{question.class.name.downcase}_#{question.id}")
      sleep 1
      expect(question.rating).to eq 0
    end
  end

  describe 'Unauthorized user' do
    scenario 'can`t vote for question' do
      visit question_path(question)
      expect(page).to_not have_link("rating_buttons_#{question.name_id}")
    end

    scenario 'can`t vote for answer' do
      visit question_path(question)
      expect(page).to_not have_link("rating_buttons_#{answer.name_id}")
    end
  end
end
