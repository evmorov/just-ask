class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, :body, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
