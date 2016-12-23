class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 5 }
end
