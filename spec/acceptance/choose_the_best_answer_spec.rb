require_relative 'acceptance_helper'

feature 'Choose the best answer', '
  In order to show people that the answer helped me
  As a user
  I want to be able to choose the best answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, body: 'answer1') }
  given!(:answer2) { create(:answer, question: question, body: 'answer2') }
  given!(:answer3) { create(:answer, question: question, body: 'answer3') }

  context 'When authenticated' do
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

  context 'When unauthenticated' do
    scenario "don't see choose the best answer link" do
      visit question_path(question)

      expect(page).to_not have_selector '.best-answer-link'
    end

    scenario 'see the sign of the best answer' do
      best_answer = create(:answer, question: question, body: 'the best answer', best: true)

      visit question_path(question)

      puts page.text
      expect(
        find("#best-answer-link-#{best_answer.id}"
      )['class']).to include('best-answer-link-choosen')
    end
  end
end
