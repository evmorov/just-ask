require_relative '../acceptance_helper'

feature 'Add a comment to the question', '
  In order to ask the author or clarify something
  As an authenticated user
  I want to be able to add a comment to the question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'When authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add a comment', js: true do
      within('#question') do
        click_on 'Add a comment'
        fill_in 'comment_body', with: 'This is a comment'
        click_on 'Create Comment'

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'This is a comment'
      end
    end

    scenario "can't add an invalid comment", js: true do
      within('#question') do
        click_on 'Add a comment'
        fill_in 'comment_body', with: 'qwe'
        click_on 'Create Comment'

        expect(page).to have_selector 'textarea'
        expect(page).to_not have_content 'qwe'
        expect(page).to have_content 'Body is too short'
      end
    end
  end

  context 'When unauthenticated' do
    given!(:comment) { create(:comment, commentable: question, body: 'Some comment') }

    background do
      visit question_path(question)
    end

    scenario "don't see Add a comment link" do
      expect(page).to_not have_link('Add a comment')
    end

    scenario "see comments" do
      within('#question') do
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
        within('#question') do
          click_on 'Add a comment'
          fill_in 'comment_body', with: 'This is a comment'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('another_user') do
        within('#question') do
          expect(page).to have_content 'This is a comment'
        end
      end
    end
  end
end
