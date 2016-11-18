require 'rails_helper'

feature 'Remove an answer', '
  In order to change the history
  As a user
  I want to be able to remove my own answers
' do

  context 'When authenticated' do
    before do
      @me = create(:user)
      @stranger = create(:user)
      @question = create(:question)
      @my_answer = create(:answer, body: 'My answer', question: @question, user: @me)
      @strangers_answer = create(:answer, body: 'Not mine', question: @question, user: @stranger)

      sign_in(@me)
      visit question_path(@question)
    end

    scenario 'Remove my own answer' do
      within(:xpath, "//p[text()='#{@my_answer.body}']") do
        click_on 'Remove'
      end

      expect(page).to_not have_content @my_answer.body
      expect(page).to have_content @strangers_answer.body
    end

    scenario 'There is no remove button for answers by different authors' do
      within(:xpath, "//p[text()='#{@strangers_answer.body}']") do
        expect(page).to_not have_selector(:link_or_button, 'Remove')
      end
    end
  end

  context 'Non-authenticated' do
    given(:question_with_answers) { create(:question_with_answers) }

    scenario 'There are no remove buttons for answers' do
      visit question_path(question_with_answers)
      expect(page).to_not have_selector(:link_or_button, 'Remove')
    end
  end
end
