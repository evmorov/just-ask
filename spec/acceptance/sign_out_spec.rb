require_relative 'acceptance_helper'

feature 'Signing out', '
  In order to be more secure
  As an authenticated user
  I want be able to sign out
' do

  given(:user) { create(:user) }

  scenario 'Sign out when authenticated' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to_not have_content user.email
  end

  scenario 'Sign out link absents when unauthenticated' do
    visit root_path

    expect(page).to_not have_link('Sign out')
  end
end
