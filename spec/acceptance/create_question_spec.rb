require 'rails_helper'

feature 'Create a question', '
  In order to get an answer from community
  As an user
  I want to be able to ask a question
' do

  given(:user) { create(:user) }

  scenario 'Create a question when authenticated' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Create a question when non-authenticated' do
    sign_in(user)
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Post Your Question'

    expect(page).to have_content 'Your question successfully created.'
  end
end
