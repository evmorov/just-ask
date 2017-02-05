shared_examples_for 'Comments' do
  context 'When authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add a comment', js: true do
      within(commentable_locator) do
        click_on 'Add a comment'
        fill_in 'comment_body', with: 'This is a comment'
        click_on 'Create Comment'

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'This is a comment'
      end
    end

    scenario "can't add an invalid comment", js: true do
      within(commentable_locator) do
        click_on 'Add a comment'
        fill_in 'comment_body', with: 'qwe'
        click_on 'Create Comment'

        expect(page).to have_selector 'textarea'
        expect(page).to_not have_content 'qwe'
        expect(page).to have_content 'body is too short'
      end
    end
  end

  context 'When unauthenticated' do
    background do
      visit question_path(question)
    end

    scenario "don't see Add a comment link" do
      expect(page).to_not have_link('Add a comment')
    end

    scenario 'see comments' do
      within(commentable_locator) do
        expect(page).to have_content 'Some comment'
      end
    end
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
        within(commentable_locator) do
          click_on 'Add a comment'
          fill_in 'comment_body', with: 'This is a comment'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('another_user') do
        within(commentable_locator) do
          expect(page).to have_content 'This is a comment'
        end
      end
    end
  end
end

