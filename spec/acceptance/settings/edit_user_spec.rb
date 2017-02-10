require_relative '../acceptance_helper'

feature 'Edit user', '
  In order to change my profile
  As a user
  I want to be able to edit my profile
' do

  given(:user) { create(:user) }

  background do
    sign_in user
  end

  scenario 'Can open my Edit profile page' do
    click_on user.email

    expect(page).to have_content 'Edit User'
  end
end
