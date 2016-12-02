require_relative '../acceptance_helper'

feature 'Logo in the header', '
  In order to go to the root page
  As a user
  I want to be able click the logo
' do

  given(:question) { create(:question) }

  scenario 'Click the logo from Question page' do
    visit question_path(question)
    click_on 'logo'

    expect(page).to have_current_path(root_path)
  end
end
