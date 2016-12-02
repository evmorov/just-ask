require_relative '../acceptance_helper'

feature 'Signing in', '
  In order to be able ask questions
  As an user
  I want be able to sign in
' do

  given(:user) { create(:user) }

  scenario 'Sign in for existing user' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content user.email
  end

  scenario 'Try to sign in for non-existing user' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
