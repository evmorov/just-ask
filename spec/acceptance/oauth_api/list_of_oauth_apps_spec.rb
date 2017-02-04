require_relative '../acceptance_helper'

feature 'List of oauth application', '
  In order to controll API
  As an administrator
  I want be able to view oauth applications
' do

  context 'When admin' do
    given(:user) { create(:admin) }
    given!(:apps) { create_list(:oauth_application, 3) }

    scenario 'can view list of apps' do
      sign_in(user)
      visit oauth_applications_path

      expect(page).to have_content 'Your applications'
      apps.each do |app|
        expect(page).to have_content app.name
      end
    end
  end

  context 'When user' do
    given(:user) { create(:user) }

    scenario 'can view apps' do
      sign_in(user)
      visit oauth_applications_path

      expect(page).to have_content 'You are already signed in.'
      expect(page).to have_current_path(root_path)
    end
  end

  context 'When unauthenticated' do
    scenario 'can view apps' do
      visit oauth_applications_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
