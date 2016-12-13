module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    has_many :votes, as: :votable

    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
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
      vote_by_user.destroy! if vote_by_user
      votes.create!(score: score, user: user) if vote_by_user.try(:score) != score
    end
  end
end
