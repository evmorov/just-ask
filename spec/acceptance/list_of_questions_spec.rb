require 'rails_helper'

feature 'List of questions', '
  In order to find a question
  As a user
  I want to be able to view all questions
' do

  before do
    create(:question, title: 'First')
    create(:question, title: 'Second')
  end

  scenario 'See List of questions when non-authenticated' do
    visit questions_path

    expect(page).to have_link('First')
    expect(page).to have_link('Second')
  end
end
