require_relative '../acceptance_helper'

feature 'Daily digest', '
  In order to get an email about new questions
  As an user
  I want to be able to receive daily digest with new questions created within 24 hours
' do

  given(:users) { create_list(:user, 2) }
  given!(:questions_digest) { create_list(:question, 2, user: users.first, created_at: 1.day.ago) }
  given!(:old_questions) do
    create_list(:question, 2, user: users.first, created_at: (Date.yesterday.midnight - 1))
  end
  given!(:new_questions) do
    create_list(:question, 2, user: users.first, created_at: Date.today.midnight)
  end

  scenario 'Every user receives an email with all new questions' do
    DailyDigestJob.perform_now

    users.each do |user|
      open_email user.email

      old_questions.each do |question|
        expect(current_email).to_not have_link(question.title)
      end

      new_questions.each do |question|
        expect(current_email).to_not have_link(question.title)
      end

      questions_digest.each do |question|
        expect(current_email).to have_link(question.title, href: question_url(question))
      end

      expect(all_emails.size).to eq(users.size)
    end
  end
end
