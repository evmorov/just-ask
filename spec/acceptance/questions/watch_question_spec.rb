require_relative '../acceptance_helper'

feature 'Question notification', '
  In order to receive notification about a question
  As a user
  I want to be able to watch the question
' do

  given(:question) { create(:question) }
  given(:author) { question.user }
  given!(:another_user) { create(:user) }

  context 'When the author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'the question is watched by default' do
      within('#question-notification') do
        expect(page).to have_content 'unwatch'
      end
    end

    scenario 'can unwatch the question', js: true do
      within('#question-notification') do
        click_on 'unwatch'

        expect(page).to have_content 'watch'
        expect(page).to_not have_content 'unwatch'
      end
    end
  end

  context 'When a user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario "the question isn't watched by default" do
      within('#question-notification') do
        expect(page).to have_content 'watch'
        expect(page).to_not have_content 'unwatch'
      end
    end

    scenario 'can watch the question', js: true do
      within('#question-notification') do
        click_on 'watch'

        expect(page).to have_content 'unwatch'
      end
    end
  end

  context 'When unauthorized' do
    before do
      visit question_path(question)
    end

    scenario 'there is no button for watching' do
      within('#question-notification') do
        expect(page).to_not have_content 'watch'
        expect(page).to_not have_content 'unwatch'
      end
    end
  end

  context 'Email notification' do
    given(:watching_user) { create(:user) }
    given!(:not_watching_user) { create(:user) }

    before do
      create(:question_notification, user: watching_user, question: question)

      sign_in(author)
      visit question_path(question)
    end

    scenario 'Users watching a question get an email with the new answer', js: true do
      new_answer_message = 'My new answer message'
      fill_in 'Add answer', with: new_answer_message
      click_on 'Create Answer'

      [author, watching_user].each do |user|
        wait_for_email_for user
        open_email user.email

        expect(current_email).to have_link(question.title, href: question_url(question))
        expect(current_email).to have_content(new_answer_message)
      end

      expect(all_emails.size).to eq(2)
    end
  end
end
