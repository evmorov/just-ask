require_relative '../acceptance_helper'

feature 'Remove an answer', '
  In order to change the history
  As a user
  I want to be able to remove my own answers
' do

  context 'When authenticated' do
    given(:me) { create(:user) }
    given(:stranger) { create(:user) }
    given(:question) { create(:question) }
    given!(:my_answer) { create(:answer, question: question, user: me) }
    given!(:strangers_answer) { create(:answer, question: question, user: stranger) }

    background do
      sign_in(me)
      visit question_path(question)
    end

    scenario 'remove my own answer', js: true do
      within('div', text: my_answer.body, class: 'answer') do
        click_on 'Remove'
        page.driver.browser.accept_js_confirms
      end

      expect(page).to_not have_content my_answer.body
      expect(page).to have_content strangers_answer.body
    end

    scenario 'there is no remove button for answers by different authors' do
      within('p', text: strangers_answer.body) do
        expect(page).to_not have_link('Remove')
      end
    end
  end

  context 'When unauthenticated' do
    given(:question_with_answers) { create(:question_with_answers) }

    scenario 'there are no remove buttons for answers' do
      Capybara.exact = true
      visit question_path(question_with_answers)
      expect(page).to_not have_link('Remove')
    end
  end
end
