class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  respond_to :json

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    respond_with @comment
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

    ActionCable.server.broadcast('comments', @comment)
  end
end
