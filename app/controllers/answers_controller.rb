class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :best]
  before_action :set_comment, only: [:create, :update]

  after_action :publish_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @question = @answer.question
    if current_user.author_of? @answer
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of? @answer
      @answer.destroy
    else
      head :forbidden
    end
  end

  def best
    if current_user.author_of? @answer.question
      @answer.toggle_best
    else
      head :forbidden
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    vote = { state: @answer.vote_state(current_user), score: @answer.total_score }
    ActionCable.server.broadcast('answers', {
      answer: @answer,
      vote: vote,
      attachments: @answer.attachments
    })
  end

  def set_comment
    @comment = Comment.new
  end
end
