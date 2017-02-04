require_relative '../acceptance_helper'

feature 'Vote on question', '
  In order to show that I like a question
  As an authenticated user
  I want to be able to vote on a question
' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:my_question) { create(:question, user: user) }
  given(:question) { create(:question) }

  it_behaves_like 'Giving vote on votable' do
    let(:votable) { question }
    let(:votable_locator) { '#question' }
  end

  scenario "can't upvote my own question", js: true do
    sign_in(user)
    visit question_path(my_question)

    within('#question') do
      find(:css, '.upvote-link').trigger('click')
      wait_for_ajax

      expect(find('.vote')['class']).to_not include('upvoted')
      expect(find('.vote')['class']).to_not include('downvoted')
      expect(find('.score')).to have_content('0')
    end
  end
end
