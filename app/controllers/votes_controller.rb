class VotesController < ApplicationController
  before_action :authenticate_user!

  def upvote
    create_vote(1)
  end

  def downvote
    create_vote(-1)
  end

  private

  def create_vote(score)
    votable = find_votable

    vote = Vote.find_by(votable: votable, user: current_user)

    if !vote || (vote && vote.score != score)
      votable.votes.create(score: score, user: current_user)
    end

    if vote
      vote.destroy
    end
  end

  def find_votable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
