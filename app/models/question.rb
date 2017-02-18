class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true, length: { minimum: 5 }

  default_scope { order(:created_at) }

  after_commit :watch_question, on: :create

  private

  def watch_question
    subscriptions.create(user: user)
  end
end
