# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide addtional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Lexxicus/208fbcecfbb1eb6cb5422a1eaf727c8c' }

  scenario 'User adds link when asks question', js: true do
    sign_in(question.user)

    visit question_path(question)

    fill_in 'Create your answer', with: 'Answer body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
