class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @question
  end

  def destroy
    answer = Answer.find(params[:id])
    question = answer.question

    if current_user.author_of? answer
      answer.destroy
    else
      flash[:error] = 'You can remove only your answer'
    end

    redirect_to question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
