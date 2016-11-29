class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy]

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
    @answer = Answer.find(params[:answer_id])
    @answer.toggle_best
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
