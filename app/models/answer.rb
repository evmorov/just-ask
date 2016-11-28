class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(:created_at) }

  def toggle_best
    transaction do
      the_best_answer = question.answers.find_by(best: true)
      if the_best_answer
        the_best_answer.best = false
        the_best_answer.save
      end

      self.best = !best
      save
    end
  end
end
