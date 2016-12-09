module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    has_many :votes, as: :votable

    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end
end
