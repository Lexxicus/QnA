# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question_with_file) { create(:question_with_file) }
  given(:url) { 'https://google.com' }
  given(:question_with_links) { create(:question_with_links) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question_with_file)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Author' do
    background do
      sign_in(question_with_file.user)
      visit edit_question_path(question_with_file)
    end

    scenario 'edits his question', js: true do
      fill_in 'question[title]',	with: 'edited title'
      fill_in 'question[body]',	with: 'edited body'
      click_on 'Ask'

      expect(page).to_not have_content question_with_file.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'edits his question with errors', js: true do
      fill_in 'question[title]',	with: ''
      fill_in 'question[body]',	with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'attach files to question', js: true do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete attached fiel to question', js: true do
      click_on(id: "delete-file-#{question_with_file.files.first.id}")

      expect(page).to have_no_link question_with_file.files.first.filename.to_s
    end

    scenario 'add links while editing question', js: true do
      click_on 'add link'

      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_content 'Google'
    end
  end

  describe 'Authenticate user' do
    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question_with_file)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
