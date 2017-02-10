class SubscriptionsController < ApplicationController
  before_action :load_subscription, only: :destroy

  authorize_resource

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with @subscription
  end

  def destroy
    @question = @subscription.question
    respond_with(@subscription.destroy)
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
