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

  context 'When authenticated' do
    background do
      sign_in(user)
    end

    scenario 'vote on an answer', js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario 'unvote the answer', js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end

    scenario 'downvote an answer', js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.downvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to include('downvoted')
        expect(find('.score')).to have_content('-1')
      end
    end

    scenario 'downvote if already upvoted', js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax
        find(:css, '.downvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to include('downvoted')
        expect(find('.score')).to have_content('-1')
      end
    end

    scenario 'upvote if already downvoted', js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.downvote-link').trigger('click')
        wait_for_ajax
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario "can't upvote my own answer", js: true do
      visit question_path(question)

      within("#answer_#{my_answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end

    scenario 'upvote when an answer is already upvoted by another user', js: true do
      create(:vote, user: another_user, votable: answer)

      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('2')
      end
    end
  end

  context 'When unauthenticated' do
    scenario "can't vote on an answer", js: true do
      visit question_path(question)

      within("#answer_#{answer.id}") do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
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
