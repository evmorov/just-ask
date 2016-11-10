class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all

  validates :title, :body, presence: true, length: { minimum: 5 }
end
