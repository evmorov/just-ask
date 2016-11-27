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

      answers_text = page.all(:css, '.answer').map(&:text)
      expect(answers_text).to eq(%w(answer1 answer2 answer3))
      within("#answer-#{answer2.id}") do
        find(:css, '.best-answer').trigger('click')
      end

      sleep 1
      answers_text = page.all(:css, '.answer').map(&:text)
      expect(answers_text).to eq(%w(answer2 answer1 answer3))
      expect(find(:css, '.best-answer').class).to include('best-choosen')
    end

    scenario 'choose another best answer', js: true
    scenario 'cancel the best answer', js: true
  end
end
