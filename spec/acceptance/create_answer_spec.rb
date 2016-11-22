require_relative 'acceptance_helper'

feature 'Create an answer', '
  In order to help people
  As a user
  I want to be able to create an answer
' do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'When authenticated' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Create an answer when authenticated', js: true do
      fill_in 'answer_body', with: 'My smart answer'
      click_on 'Create Answer'

      within('.answers') do
        expect(page).to have_content 'My smart answer'
      end
    end

    scenario 'Create an invalid answer when non-authenticated', js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body is too short"
    end
  end

  context 'When non-authenticated' do
    scenario 'Create an answer' do
      visit question_path(question)
      fill_in 'answer_body', with: 'My smart answer'
      click_on 'Create Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
