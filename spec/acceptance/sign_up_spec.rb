require 'rails_helper'

feature 'Signing up', '
  In order to be able all features of the web-site
  As a non-registred user
  I want be able to register
' do

  scenario 'Sign up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    within('#new_user') do
      click_on 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
