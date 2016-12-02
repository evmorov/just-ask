require_relative '../acceptance_helper'

feature 'List of questions', '
  In order to find a question
  As a user
  I want to be able to view all questions
' do

  given!(:list_of_questions) { create_list(:question, 10) }

  scenario 'View List of questions' do
    visit questions_path
    list_of_questions.each do |question|
      expect(page).to have_link(question.title)
    end
  end
end
