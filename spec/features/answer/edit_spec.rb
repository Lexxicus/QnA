# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:answer_with_file) { create(:answer_with_file) }
  given(:url) { 'http://google.com' }

  scenario 'Unauthenticated can not adit answer' do
    visit question_path(answer_with_file.question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author' do
    background do
      sign_in(answer_with_file.user)
      visit question_path(answer_with_file.question)
      click_on 'Edit'
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer',	with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer_with_file.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'attach files to answer', js: true do
      within '.answers' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete attached fiel to answer', js: true do
      click_on(id: "delete-file-#{answer_with_file.files.first.id}")

      expect(page).to have_no_link answer_with_file.files.first.filename.to_s
    end

    scenario 'add links while edit answer', js: true do
      within '.answers' do
        click_on 'add link'

        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: url

        click_on 'Save'
      end

      expect(page).to have_content 'Google'
    end
  end

  describe 'Authenticate user' do
    scenario "tries to edit other user's answers" do
      sign_in(user)
      visit question_path(answer_with_file.question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
