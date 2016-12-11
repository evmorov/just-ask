module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user.id)

    respond_to do |format|
      format.json { render json: @votable }
    end
  end

  def downvote
    @votable.downvote(current_user.id)

    respond_to do |format|
      format.json { render json: @votable }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
