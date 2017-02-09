require_relative '../acceptance_helper'

feature 'Sidekiq Web UI', '
  In order to monitor queue tasks
  As an administrator
  I want to be able to open Web UI monitor page
' do

  context 'When administrator' do
    given(:user) { create(:admin) }

    scenario 'can open the monitor page' do
      sign_in(user)
      visit sidekiq_web_path

      expect(page).to have_current_path(sidekiq_web_path)
    end
  end

  context 'When an user' do
    given(:user) { create(:user) }

    scenario "can't open the monitor page" do
      sign_in(user)

      expect {
        visit sidekiq_web_path
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
