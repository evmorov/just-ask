require_relative 'acceptance_helper'

feature 'Choose the best answer', '
  In order to show people that the answer helped me
  As a user
  I want to be able to choose the best answer
' do

  context 'When authenticated' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:answer1) { create(:answer, question: question, body: 'answer1') }
    given!(:answer2) { create(:answer, question: question, body: 'answer2') }
    given!(:answer3) { create(:answer, question: question, body: 'answer3') }

    scenario 'choose the best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{answer2.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      choosen_answer_class = 'best-answer-link-choosen'
      expect(find("#best-answer-link-#{answer1.id}")['class']).to_not include(choosen_answer_class)
      expect(find("#best-answer-link-#{answer2.id}")['class']).to include(choosen_answer_class)
      expect(find("#best-answer-link-#{answer3.id}")['class']).to_not include(choosen_answer_class)
    end
  end
end
