require_relative 'acceptance_helper'

feature 'Select the best answer', '
  In order to show people that the answer helped me
  As a user
  I want to be able to select the best answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, body: 'answer1') }
  given!(:answer2) { create(:answer, question: question, body: 'answer2') }
  given!(:answer3) { create(:answer, question: question, body: 'answer3') }

  context 'When authenticated' do
    scenario 'select the best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{answer2.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      selected_answer_class = 'best-answer-link-selected'
      expect(find("#best-answer-link-#{answer1.id}")['class']).to_not include(selected_answer_class)
      expect(find("#best-answer-link-#{answer2.id}")['class']).to include(selected_answer_class)
      expect(find("#best-answer-link-#{answer3.id}")['class']).to_not include(selected_answer_class)
    end
  end

  context 'When unauthenticated' do
    scenario "don't see selecte the best answer link" do
      visit question_path(question)

      expect(page).to_not have_selector '.best-answer-link'
    end

    scenario 'see the sign of the best answer' do
      best_answer = create(:answer, question: question, body: 'the best answer', best: true)

      visit question_path(question)

      puts page.text
      expect(
        find("#best-answer-link-#{best_answer.id}"
      )['class']).to include('best-answer-link-selected')
    end
  end
end
