class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions_ids = Question.where(created_at: 1.day.ago..Time.now).ids
    User.find_each do |user|
      DailyMailer.digest(user, questions_ids).deliver_later
    end
  end
end
