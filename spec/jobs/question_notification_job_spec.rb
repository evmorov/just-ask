require 'rails_helper'

describe QuestionNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:watching_user) { create(:user) }
  let!(:notification) { create(:question_notification, user: watching_user, question: question) }
  let!(:not_watching_users) { create_list(:user, 2) }

  it 'sends a new answer to users watching the question' do
    answer = create(:answer, question: question)

    [question.user, watching_user].each do |user|
      expect(AnswerMailer).to receive(:notify_watcher).with(user, answer).and_call_original
    end
    not_watching_users.each do |user|
      expect(AnswerMailer).to_not receive(:notify_watcher).with(user, answer).and_call_original
    end
    QuestionNotificationJob.perform_now(answer)
  end
end
