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

  context 'When authenticated' do
    background do
      sign_in(user)
    end

    scenario 'upvote on a question', js: true do
      visit question_path(question)

      within('#question') do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario 'unvote the question', js: true do
      visit question_path(question)

      within('#question') do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end

    scenario 'downvote a question', js: true do
      visit question_path(question)

      within('#question') do
        find(:css, '.downvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to include('downvoted')
        expect(find('.score')).to have_content('-1')
      end
    end

    scenario 'downvote if already upvoted', js: true do
      visit question_path(question)

      within('#question') do
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

      within('#question') do
        find(:css, '.downvote-link').trigger('click')
        wait_for_ajax
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario "can't upvote my own question", js: true do
      visit question_path(my_question)

      within('#question') do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end

    scenario 'upvote when a question is already upvoted by another user', js: true do
      create(:vote, user: another_user, votable: question)

      visit question_path(question)

      within('#question') do
        find(:css, '.upvote-link').trigger('click')
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('2')
      end
    end
  end

  context 'When unauthenticated' do
    scenario "can't upvote a question", js: true do
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
end
