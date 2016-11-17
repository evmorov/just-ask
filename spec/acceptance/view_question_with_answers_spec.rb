require 'rails_helper'

feature 'View Question with answers', '
  In order to understand a question and find the right answer
  As a user
  I want to be able to view a question with answers
' do

  given(:question_with_answers) { create(:question_with_answers) }

  scenario 'View a question with answers' do
    visit question_path(question_with_answers)

    expect(page).to have_content(question_with_answers.title)
    expect(page).to have_content(question_with_answers.body)
    question_with_answers.answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
