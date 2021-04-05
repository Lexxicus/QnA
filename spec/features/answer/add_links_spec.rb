# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide addtional info to my answer
  As an answer author
  I'd like to be able to add links
" do
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Lexxicus/208fbcecfbb1eb6cb5422a1eaf727c8c' }

  background do
    sign_in(question.user)
    visit question_path(question)

    fill_in 'Create your answer', with: 'Answer body'
    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'Url', with: gist_url

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User give answer with invalid url', js: true do
    fill_in 'Url', with: 'fihsing_url.com'

    click_on 'Send answer'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to_not have_link 'My gist', href: 'fihsing_url.com'
  end
end
