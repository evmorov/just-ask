require 'rails_helper'

feature 'Create an answer', '
  In order to help people
  As a user
  I want to be able to create an answer
' do

  given(:question) { create(:question) }

  scenario 'Create an answer when non-authenticated' do
    visit question_path(question)

    fill_in 'answer_body', with: 'My smart answer'
    click_on 'Create Answer'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content('My smart answer')
  end
end
