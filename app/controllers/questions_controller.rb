class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]
  before_action :build_answer, only: :show

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', @question)
  end
end
