require_relative '../acceptance_helper'

feature 'Create an answer', '
  In order to help people
  As a user
  I want to be able to create an answer
' do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'When authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer', js: true do
      new_answer_message = 'My new answer message'
      fill_in 'Add answer', with: new_answer_message
      click_on 'Create Answer'

      within('#answers') { expect(page).to have_content(new_answer_message) }
      expect(page).to_not have_field('Add answer', with: new_answer_message)
    end

    scenario 'create an invalid answer', js: true do
      click_on 'Create Answer'

      expect(page).to have_content 'Body is too short'
    end
  end

  context 'When unauthenticated' do
    scenario 'create an answer' do
      visit question_path(question)
      fill_in 'Add answer', with: 'My smart answer'
      click_on 'Create Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'Mulitple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add answer', with: 'My answer'
        click_on 'Create Answer'
      end

      Capybara.using_session('guest') do
        within('#answers') do
          expect(page).to have_content user.username
          expect(page).to have_content('My answer')
        end
      end
    end
  end
end
