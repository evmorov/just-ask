module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:upvote, :downvote]
    before_action :set_votable, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user)
    authorize! :upvote, @votable
    respond_to_json
  end

  def downvote
    @votable.downvote(current_user)
    authorize! :downvote, @votable
    respond_to_json
  end

  private

  def respond_to_json
    respond_to do |format|
      format.json do
        json = {
          votable_name: @votable.model_name.param_key,
          votable_id: @votable.id,
          vote_state: @votable.vote_state(current_user),
          total_score: @votable.total_score
        }
        render json: json
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
