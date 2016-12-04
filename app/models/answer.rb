class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(:created_at) }

  def toggle_best
    transaction do
      the_best_answer = question.answers.find_by(best: true)
      the_best_answer.update!(best: false) if the_best_answer
      update!(best: !best)
    end
  end
end
