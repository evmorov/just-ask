module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    has_many :votes, as: :votable
  end

  def upvote(user)
    give_vote(1, user)
  end

  def downvote(user)
    give_vote(-1, user)
  end

  def vote_state(user)
    vote_by_user = votes.find_by(user: user)
    return unless vote_by_user

    if vote_by_user.score.positive?
      :upvoted
    elsif vote_by_user.score.negative?
      :downvoted
    end
  end

  def total_score
    votes.sum(:score)
  end

  private

  def give_vote(score, user)
    return if user.author_of? self

    transaction do
      vote_by_user = Vote.find_by(votable: self, user: user)
      vote_by_user&.destroy!
      votes.create!(score: score, user: user) if vote_by_user.try(:score) != score
    end
  end
end
