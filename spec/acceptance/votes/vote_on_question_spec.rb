require_relative '../acceptance_helper'

feature 'Vote on question', '
  In order to show that I like a question
  As an authenticated user
  I want to be able to vote on a question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'When authenticated' do
    background do
      sign_in(user)
    end

    scenario 'vote on a question', js: true do
      visit question_path(question)

      find(:css, '#upvote-question').trigger('click')

      expect(find('#upvote-question')['class']).to include('active')
      expect(find('#question-score')).to have_content('1')
    end

    scenario 'unvote the question'
    scenario 'downvote a question'
    scenario 'downvote if already upvoted'
    scenario 'upvote if already downvoted'
    scenario "can't vote for my own question"
    scenario "can't vote twice"
    scenario 'vote when a question is already voted by another user'
  end
end
