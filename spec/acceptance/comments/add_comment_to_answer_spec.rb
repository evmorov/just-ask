require_relative '../acceptance_helper'

feature 'Add a comment to the answer', '
  In order connect with other people
  As an authenticated user
  I want to be able to add a comment to the answer
' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, body: 'Some comment') }

  it_behaves_like 'Comments' do
    let(:commentable_locator) { "#answer_#{answer.id}" }
  end
end
