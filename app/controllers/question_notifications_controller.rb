class QuestionNotificationsController < ApplicationController
  before_action :load_notification, only: :destroy

  authorize_resource

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @question_notification = @question.question_notifications.new
    @question_notification.user = current_user
    @question_notification.save
    respond_with @question_notification
  end

  def destroy
    @question = @question_notification.question
    respond_with(@question_notification.destroy)
  end

  private

  def load_notification
    @question_notification = QuestionNotification.find(params[:id])
  end
end
