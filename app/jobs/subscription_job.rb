class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      AnswerMailer.notify_watcher(user, answer).deliver_later
    end
  end
end
