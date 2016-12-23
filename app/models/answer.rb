class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(:created_at) }

  def toggle_best
    transaction do
      the_best_answer = question.answers.find_by(best: true)
      the_best_answer.update!(best: false) if the_best_answer
      update!(best: !best)
    end
  end
end
