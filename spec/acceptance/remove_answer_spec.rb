require_relative 'acceptance_helper'

feature 'Remove an answer', '
  In order to change the history
  As a user
  I want to be able to remove my own answers
' do

  context 'When authenticated' do
    given(:me) { create(:user) }
    given(:stranger) { create(:user) }
    given(:question) { create(:question) }
    given(:my_answer) { create(:answer, question: question, user: me) }
    given(:strangers_answer) { create(:answer, question: question, user: stranger) }

    before do
      my_answer
      strangers_answer

      sign_in(me)
      visit question_path(question)
    end

    scenario 'Remove my own answer' do
      within('p', text: my_answer.body) do
        click_on 'Remove'
      end

      expect(page).to_not have_content my_answer.body
      expect(page).to have_content strangers_answer.body
    end

    scenario 'There is no remove button for answers by different authors' do
      within('p', text: strangers_answer.body) do
        expect(page).to_not have_link('Remove')
      end
    end
  end

  context 'Non-authenticated' do
    given(:question_with_answers) { create(:question_with_answers) }

    scenario 'There are no remove buttons for answers' do
      visit question_path(question_with_answers)
      expect(page).to_not have_link('Remove')
    end
  end
end
