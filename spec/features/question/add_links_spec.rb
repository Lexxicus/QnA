# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide addtional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Lexxicus/208fbcecfbb1eb6cb5422a1eaf727c8c' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'test text text'
    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when asks question' do
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds invalid link when asks question' do
    fill_in 'Url', with: 'fihsing_url.com'

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to_not have_link 'My gist', href: 'fihsing_url.com'
  end
end
