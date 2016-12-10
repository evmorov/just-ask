module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    has_many :votes, as: :votable

    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def upvote(params)
    give_vote(1, params)
  end

  def downvote(params)
    give_vote(-1, params)
  end

  private

  def give_vote(score, params)
    transaction do
      user_id = params[:user_id]
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
