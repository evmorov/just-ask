require_relative '../acceptance_helper'

feature 'Remove a file', '
  In order to change the history
  As a user
  I want to be able to remove files
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attach_question) { create(:attachment, attachable: question) }
  given!(:attach_answer) { create(:attachment, attachable: answer) }

  given(:another_user) { create(:user) }

  context 'When authenticated' do
    context 'remove my own attachments' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'remove a file for my own question', js: true do
        within('#question') do
          find(:css, '.remove-attachment-link').trigger('click')

          expect(page).to_not have_link(
            attach_question.file.identifier,
            href: attach_question.file.url
          )
        end
      end

      scenario 'remove a file for my own answer', js: true do
        within('#answers') do
          find(:css, '.remove-attachment-link').trigger('click')

          expect(page).to_not have_link(
            attach_question.file.identifier,
            href: attach_question.file.url
          )
        end
      end
    end

    context "another user can't remove my attachments" do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'no remove icon for my question' do
        within('#question') do
          expect(page).to_not have_css('.remove-attachment-link')
        end
      end

      scenario 'no remove icon for my answer' do
        within('#answers') do
          expect(page).to_not have_css('.remove-attachment-link')
        end
      end
    end
  end

  context 'When unauthenticated' do
    background do
      visit question_path(question)
    end

    scenario 'do not see a remove icon for a question' do
      within('#question') do
        expect(page).to_not have_css('.remove-attachment-link')
      end
    end

    scenario 'do not see a remove icon for an answer' do
      within('#answers') do
        expect(page).to_not have_css('.remove-attachment-link')
      end
    end
  end
end
