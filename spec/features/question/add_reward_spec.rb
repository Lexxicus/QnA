require 'rails_helper'

feature 'User can add reward to best answer', "
  In order to encourage best answer
  As an question's author
  I'd like to be able to add award for best answer
" do
  given(:user)      { create(:user) }
  given(:question)  { create(:question, user: user) }

  before do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'question[title]', with: 'Title of question'
    fill_in 'question[body]', with: 'Body of question'
  end

  scenario 'User adds award when asks question' do
    within '.reward' do
      fill_in 'Title', with: 'best answer'
      attach_file 'Image', "#{Rails.root}/spec/files/test.jpg"
    end

    click_on 'Ask'

    expect(page).to have_content 'best answer'
  end

  scenario 'User adds invalid award when asks question' do
    within '.reward' do
      fill_in 'Title', with: 'best answer'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask'

    expect(page).to have_content 'Reward image has an invalid content type'
  end
end
