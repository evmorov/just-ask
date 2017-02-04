require_relative '../acceptance_helper'

feature 'Vote on answer', '
  In order to show that I like an answer
  As an authenticated user
  I want to be able to vote on an answer
' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:my_answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'Giving vote on votable' do
    let(:votable) { answer }
    let(:votable_locator) { "#answer_#{answer.id}" }
  end

  scenario "can't upvote my own answer", js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer_#{my_answer.id}") do
      find(:css, '.upvote-link').trigger('click')
      wait_for_ajax

      expect(find('.vote')['class']).to_not include('upvoted')
      expect(find('.vote')['class']).to_not include('downvoted')
      expect(find('.score')).to have_content('0')
    end
  end

  context 'Mulitple sessions', js: true do
    scenario "vote for the other user's answer that appeared without refreshing" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add answer', with: 'Added without page refresh'
        click_on 'Create Answer'
      end

      Capybara.using_session('another_user') do
        within all('.answer').last do
          find(:css, '.upvote-link').trigger('click')
          wait_for_ajax

          expect(find('.vote')['class']).to include('upvoted')
          expect(find('.vote')['class']).to_not include('downvoted')
          expect(find('.score')).to have_content('1')
        end
      end
    end
  end
end
