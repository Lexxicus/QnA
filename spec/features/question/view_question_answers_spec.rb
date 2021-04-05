# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question and list of answers of it', "
  In order to find question
  As an user
  I'd like to be able to view questions list
" do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'The user views the question with all the answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do
      expect(page).to have_content answer.body
    end
  end
end
