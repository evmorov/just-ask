class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true, length: { minimum: 5 }

  default_scope { order(:created_at) }
end
