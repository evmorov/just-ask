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

  context 'When authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add a comment', js: true do
      within("#answer_#{answer.id}") do
        click_on 'Add a comment'
        fill_in 'comment_body', with: 'This is a comment'
        click_on 'Create Comment'

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'This is a comment'
      end
    end

    scenario "can't add an invalid comment", js: true do
      within("#answer_#{answer.id}") do
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
    given!(:comment) { create(:comment, commentable: answer, body: 'Some comment') }

    background do
      visit question_path(question)
    end

    scenario "don't see Add a comment link" do
      expect(page).to_not have_link('Add a comment')
    end

    scenario 'see comments' do
      within("#answer_#{answer.id}") do
        expect(page).to have_content 'Some comment'
      end
    end
  end

  context 'Mulitple sessions', js: true do
    scenario 'add a comment to the answer that appeared without refreshing' do
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
          click_on 'Add a comment'
          fill_in 'comment_body', with: 'This is a comment'
          click_on 'Create Comment'

          expect(page).to_not have_selector 'textarea'
          expect(page).to have_content 'This is a comment'
        end
      end
    end

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
