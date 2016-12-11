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

  def vote_state(user_id)
    vote_by_user = Vote.find_by(votable: self, user_id: user_id)
    return unless vote_by_user

    if vote_by_user.score.positive?
      'upvoted'
    elsif vote_by_user.score.negative?
      'downvoted'
    end
  end

  def total_score
    votes.sum(:score)
  end

  private

  def give_vote(score, user_id)
    transaction do
      vote_by_user = Vote.find_by(votable: self, user_id: user_id)

      if vote_by_user
        if vote_by_user.score != score
          vote_by_user.destroy!
          votes.create!(score: score, user_id: user_id)
        end
      else
        votes.create!(score: score, user_id: user_id)
      end
    end
  end
end
