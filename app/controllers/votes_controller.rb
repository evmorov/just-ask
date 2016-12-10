class VotesController < ApplicationController
  before_action :authenticate_user!

  def upvote
    votable = find_votable

    vote = Vote.find_by(votable: votable, user: current_user)
    if vote # already voted
      vote.destroy
    else
      votable.votes.create(score: 1, user: current_user)
    end
  end

  def downvote
    votable = find_votable

    vote = Vote.find_by(votable: votable, user: current_user)
    if vote # already voted
      vote.destroy
    else
      votable.votes.create(score: -1, user: current_user)
    end
  end

  private

  def find_votable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
