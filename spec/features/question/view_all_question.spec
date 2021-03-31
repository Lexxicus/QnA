# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of questions', "
  In order to find question
  As an user
  I'd like to be able to view questions list
" do
  given!(:questions) { create_list(:question, 4) }

  scenario 'User view list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
