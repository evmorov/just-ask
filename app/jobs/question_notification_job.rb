class QuestionNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    users = User.find(answer.question.question_notifications.pluck(:user_id))
    users.each do |user|
      AnswerMailer.notify_watcher(user, answer).deliver_later
    end
  end
end
