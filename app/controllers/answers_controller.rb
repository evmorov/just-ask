class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    question = answer.question

    if current_user.author_of? answer
      answer.destroy
      redirect_to question
    else
      redirect_to question, error: 'You can remove only your answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
