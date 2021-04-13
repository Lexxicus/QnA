# frozen_string_literal: true

require 'rails_helper'

feature 'User can view his awards', "
  In order to check rewards wich i get for answers
  As an answers's author
  I'd like to be able to view my rewards
" do
  given(:user) { create(:user) }
  given(:rewards) { create(:reward, 3, user: user) }

  scenario 'User view his awards', js: true do
    sign_in(user)
    visit rewards_path

    user.rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end
end
