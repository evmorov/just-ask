class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      format.json do
        if @comment.save
          @comment_data = { comment: @comment, user: @comment.user }
          render json: @comment_data
        else
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    klass = [Question, Answer].find { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', @comment_data)
  end
end
