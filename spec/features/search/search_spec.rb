require 'sphinx_helper'

feature 'User can search', %q(
  any user should be able to search by keyword \ phrase
  with diferent type
) do
  given!(:questions) { create_list(:question, 3, title: 'Limon ask a question') }
  given!(:answers) { create_list(:answer, 2, body: 'answers for Limon questions') }
  given!(:comments) { create_list(:comment, 2, body: 'comments for Limon questions', commentable: questions[0]) }
  given!(:user) { create(:user, email: 'Limon@gmail.com') }

  shared_examples_for 'Search' do |query, times, type|
    scenario "by #{type}" do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: query
        select type, from: 'resource'
        click_on 'Search'

        expect(page).to have_content(query).exactly(times).times
      end
    end
  end

  context 'all categories', sphinx: true do
    it_should_behave_like 'Search', 'Limon', 4, 'All'
  end

  context 'questions', sphinx: true do
    it_should_behave_like 'Search', 'ask', 3, 'Question'
  end

  context 'answers', sphinx: true do
    it_should_behave_like 'Search', 'answers', 2, 'Answer'
  end

  context 'comments', sphinx: true do
    it_should_behave_like 'Search', 'comments', 2, 'Comment'
  end

  context 'users', sphinx: true do
    it_should_behave_like 'Search', 'limon', 1, 'User'
  end
end
