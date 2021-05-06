# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'Text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question succeffully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a a question with attached file' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'Text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    context 'multiple sessions ' do
      scenario 'question added on another user`s page', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('another_user') do
          visit questions_path
        end

        Capybara.using_session('user') do
          click_on 'Ask question'
          fill_in 'question[title]', with: 'Test question'
          fill_in 'question[body]', with: 'Question body'
          click_on 'Ask'

          expect(page).to have_content 'Your question succeffully created.'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'Question body'
        end

        Capybara.using_session('another_user') do
          visit questions_path

          expect(page).to have_content 'Test question'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
