class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions_ids = Question.where(created_at: Date.yesterday.midnight..Date.today.midnight - 1).ids
    User.find_each do |user|
      DailyMailer.digest(user, questions_ids).deliver_later
    end
  end
end
