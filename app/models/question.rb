class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments
end
