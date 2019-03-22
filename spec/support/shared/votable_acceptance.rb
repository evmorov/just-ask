shared_examples_for 'Giving vote on votable' do
  context 'When authenticated' do
    background do
      sign_in(user)
    end

    scenario 'upvote on a votable', js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.upvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario 'unvote if already voted', js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.upvote-link').click
        wait_for_ajax
        find(:css, '.upvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end

    scenario 'downvote a votable', js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.downvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to include('downvoted')
        expect(find('.score')).to have_content('-1')
      end
    end

    scenario 'downvote if already upvoted', js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.upvote-link').click
        wait_for_ajax
        find(:css, '.downvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to include('downvoted')
        expect(find('.score')).to have_content('-1')
      end
    end

    scenario 'upvote if already downvoted', js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.downvote-link').click
        wait_for_ajax
        find(:css, '.upvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('1')
      end
    end

    scenario 'upvote when a votable is already upvoted by another user', js: true do
      create(:vote, user: another_user, votable: votable)

      visit question_path(question)

      within(votable_locator) do
        find(:css, '.upvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('2')
      end
    end
  end

  context 'When unauthenticated' do
    scenario "can't vote on a votable", js: true do
      visit question_path(question)

      within(votable_locator) do
        find(:css, '.upvote-link').click
        wait_for_ajax

        expect(find('.vote')['class']).to_not include('upvoted')
        expect(find('.vote')['class']).to_not include('downvoted')
        expect(find('.score')).to have_content('0')
      end
    end
  end
end
