class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  def self.upvote(params)
    give_vote(params, 1)
  end

  def self.downvote(params)
    give_vote(params, -1)
  end

  private

  def self.give_vote(params, score)
    transaction do
      user = params[:user]
      votable = params[:votable]
      vote_same_attrs = Vote.find_by(votable: votable, user: user)

      if vote_same_attrs
        if vote_same_attrs.score != score
          vote_same_attrs.destroy!
          votable.votes.create!(score: score, user: user)
        end
      else
        votable.votes.create!(score: score, user: user)
      end
    end
  end
end
