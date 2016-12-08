class Question < ApplicationRecord
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 5 }
end
