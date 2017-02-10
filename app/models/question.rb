class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_notifications, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 5 }

  after_commit :watch_question, on: :create

  private

  def watch_question
    question_notifications.create(user: user)
  end
end
