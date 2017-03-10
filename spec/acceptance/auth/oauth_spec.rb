require_relative '../acceptance_helper'

feature 'OAuth', '
  In order to be able use accounts from another web-sites
  As an user
  I want be able to sing in and sign up using these accounts
' do

  before do
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  given(:user) { create(:user) }

  context 'Facebook' do
    scenario 'can sign in if have an account and Facebook is linked' do
      OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: user.email })
      user.authorizations.create(provider: 'facebook', uid: '123456')

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content user.email
      expect(page).to_not have_content 'Sign in'
    end

    scenario 'can sign in if have an account but Facebook is not linked' do
      OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: user.email })

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content user.email
      expect(page).to_not have_content 'Sign in'
    end

    scenario 'can sign up using Facebook if does not have an account' do
      OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: 'mail@facebook.com' })

      visit new_user_session_path
      click_on 'Sign in with Facebook'
      open_email 'mail@facebook.com'
      current_email.click_link 'Confirm my account'
      click_on 'Sign in with Facebook'
      fill_in 'Username', with: 'myusername'
      click_on 'Save'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'mail@facebook.com'
      expect(page).to_not have_content 'Sign in'
    end
  end

  context 'Twitter' do
    before { OmniAuth.config.add_mock(:twitter, uid: '654321') }

    scenario 'can sign in if have an account and Twitter is linked' do
      user.authorizations.create(provider: 'twitter', uid: '654321')

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content user.email
      expect(page).to_not have_content 'Sign in'
    end

    scenario 'can sign in if have an account but Twitter is not linked' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      fill_in 'Email', with: user.email
      within('.actions') do
        click_on 'Sign up'
      end
      open_email user.email
      current_email.click_link 'Confirm my account'
      click_on 'Sign in with Twitter'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content user.email
      expect(page).to_not have_content 'Sign in'
    end

    scenario 'can sign up using Twitter if does not have an account' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      fill_in 'Email', with: 'mail@twitter.com'
      within('.actions') do
        click_on 'Sign up'
      end
      open_email 'mail@twitter.com'
      current_email.click_link 'Confirm my account'
      click_on 'Sign in with Twitter'
      fill_in 'Username', with: 'myusername'
      click_on 'Save'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'mail@twitter.com'
      expect(page).to_not have_content 'Sign in'
    end
  end
end
