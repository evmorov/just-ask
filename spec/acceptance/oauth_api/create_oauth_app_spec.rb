require_relative '../acceptance_helper'

feature 'Creating oauth application', '
  In order to give ability to use API
  As an administrator
  I want be able to create oauth application
' do

  context 'When admin' do
    given(:user) { create(:admin) }

    scenario 'can create an app' do
      sign_in(user)
      visit new_oauth_application_path
      fill_in 'Name', with: 'New application'
      fill_in 'Redirect URI', with: 'https://127.0.0.1'
      fill_in 'Scopes', with: 'TestScope'
      click_on 'Submit'

      expect(page).to have_content 'Application created.'
      expect(page).to have_content 'New application'
    end
  end

  context 'When user' do
    given(:user) { create(:user) }

    scenario 'can create an app' do
      sign_in(user)
      visit new_oauth_application_path

      expect(page).to have_content 'You are already signed in.'
      expect(page).to have_current_path(root_path)
    end
  end

  context 'When unauthenticated' do
    scenario 'can create an app' do
      visit new_oauth_application_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
