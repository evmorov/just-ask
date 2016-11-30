require_relative 'acceptance_helper'

feature 'Answer editing', "
  In order to fix a mistake
  As an author of the answer
  I'd like to be able to edit my own answer
" do

  given(:question) { create(:question) }

  scenario 'Try to edit a question when unauthenticated' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'When authenticated' do
    given(:user) { create(:user) }
    given(:user_another) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:answer_not_mine) { create(:answer, question: question, user: user_another) }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can edit my own answer', js: true do
      within("#answer_#{answer.id}") do
        click_on 'Edit'
        fill_in "edit-answer-new-body-#{answer.id}", with: 'I changed my mind'
        click_on 'Save'
      end

      within('#answers') do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'I changed my mind'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edited answer is invalid', js: true do
      within("#answer_#{answer.id}") do
        click_on 'Edit'
        fill_in "edit-answer-new-body-#{answer.id}", with: ''
        click_on 'Save'
        expect(page).to have_content 'Body is too short'
      end
    end

    scenario "can't edit other user's answer" do
      within("#answer_#{answer_not_mine.id}") do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end
