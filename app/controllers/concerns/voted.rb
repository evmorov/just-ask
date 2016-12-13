module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:upvote, :downvote]
    before_action :set_votable, only: [:upvote, :downvote]
    before_action :error_if_author, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user)
    respond_to_json
  end

  def downvote
    @votable.downvote(current_user)
    respond_to_json
  end

  private

  def error_if_author
    if current_user.try(:author_of?, @votable)
      respond_to do |format|
        format.json do
          json = { error: "Can't vote when you're the author" }
          render json: json, status: :forbidden
        end
      end
    end
  end

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
