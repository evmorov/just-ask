module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    has_many :votes, as: :votable

    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def upvote(user_id)
    give_vote(1, user_id)
  end

  def downvote(user_id)
    give_vote(-1, user_id)
  end

  private

  def give_vote(score, user_id)
    transaction do
      vote_same_attrs = Vote.find_by(votable: self, user_id: user_id)

      if vote_same_attrs
        if vote_same_attrs.score != score
          vote_same_attrs.destroy!
          votes.create!(score: score, user_id: user_id)
        end
      else
        votes.create!(score: score, user_id: user_id)
      end
    end
  end
end
