require_relative '../acceptance_helper'

feature 'Add a comment to the question', '
  In order to ask the author or clarify something
  As an authenticated user
  I want to be able to add a comment to the question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question, body: 'Some comment') }

  it_behaves_like 'Comments' do
    let(:commentable_locator) { '#question' }
  end
end
