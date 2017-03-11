require_relative '../acceptance_helper'

feature 'Signing up', '
  In order to be able all features of the web-site
  As a unregistred user
  I want be able to register
' do

  scenario 'Sign up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Username', with: 'TestUserName'
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    within('#new_user') do
      click_on 'Sign up'
    end
    open_email 'test@mail.com'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Username is required' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    within('#new_user') do
      click_on 'Sign up'
    end

    expect(page).to have_content "Username can't be blank"
  end
end
