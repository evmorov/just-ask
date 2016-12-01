class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.new
  end

  def new
    @question = Question.new
    @question.attachments.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, success: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of? @question
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, error: 'You can remove only your question'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
