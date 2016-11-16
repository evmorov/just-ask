require 'rails_helper'

feature 'Create a question', '
  In order to get an answer from community
  As an user
  I want to be able to ask a question
' do

  scenario 'Create a question when non-authenticated' do
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Post Your Question'

    expect(page).to have_content 'Your question successfully created.'
  end
end
