require 'rails_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
' do

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Post Your Question'

    expect(page).to have_content 'Your question successfully created.'
  end
end
