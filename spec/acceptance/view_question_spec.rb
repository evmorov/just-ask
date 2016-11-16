require 'rails_helper'

feature 'View Question', '
  In order to understand a question and find the right answer
  As a user
  I want to be able to view a question with answers
' do

  before do
    @question = create(:question)
    @answers = %w(First Second).map do |text|
      create(:answer, question_id: @question.id, body: text)
    end
  end

  scenario 'View a question with answers' do
    visit question_path(@question)

    expect(page).to have_content(@question.title)
    expect(page).to have_content(@question.body)
    @answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
