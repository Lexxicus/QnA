require 'rails_helper'

feature 'User can view question and list of answers of it', %q{
  In order to find question
  As an user
  I'd like to be able to view questions list
} do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 4) }

  scenario 'The user views the question with all the answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
