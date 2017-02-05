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

  context 'Mulitple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within("#answer_#{answer.id}") do
          click_on 'Add a comment'
          fill_in 'comment_body', with: 'This is a comment'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('another_user') do
        within("#answer_#{answer.id}") do
          expect(page).to have_content 'This is a comment'
        end
      end
    end
  end
end
