class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(:created_at) }

  after_commit :notify_watchers, on: :create

  def toggle_best
    transaction do
      the_best_answer = question.answers.find_by(best: true)
      the_best_answer&.update!(best: false)
      update!(best: !best)
    end
  end

  private

  def notify_watchers
    QuestionNotificationJob.perform_later(self)
  end
end
