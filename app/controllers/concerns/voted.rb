module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user.id)
    respond_to_json
  end

  def downvote
    @votable.downvote(current_user.id)
    respond_to_json
  end

  private

  def respond_to_json
    respond_to do |format|
      format.json do
        if current_user.author_of? @votable
          json = { error: "Can't vote when you're the author" }
          render json: json, status: :unprocessable_entity
        else
          json = {
            votable: controller_name,
            votable_id: @votable.id,
            vote_state: @votable.vote_state(current_user.id),
            total_score: @votable.total_score
          }
          render json: json
        end
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
