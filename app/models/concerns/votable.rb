module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end
end
