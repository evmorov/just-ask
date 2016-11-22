require_relative 'acceptance_helper'

feature 'Remove a question', '
  In order I changed my mind or already found an answer
  As a user
  I want to be able to remove my own question
' do

  given(:question) { create(:question) }

  context 'When authenticated' do
    given(:user) { create(:user) }

    scenario 'Remove my own question' do
      sign_in(question.user)
      visit question_path(question)
      within('#question') do
        click_on 'Remove'
      end

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'There is no remove button for question by different author' do
      sign_in(user)
      visit question_path(question)
      within('#question') do
        expect(page).to_not have_selector(:link_or_button, 'Remove')
      end
    end
  end

  context 'Non-authenticated' do
    scenario 'There are no remove buttons for questions' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Remove')
    end
  end
end
