require 'rails_helper'

describe QuestionNotificationsController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new question notification in the database' do
        expect {
          post :create, params: { question_id: question, format: :js }
        }.to change(QuestionNotification, :count).by(1)
      end

      it 'saves the new question notification with the current user' do
        expect {
          post :create, params: { question_id: question, format: :js }
        }.to change(subject.current_user.question_notifications, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question_notification) { create(:question_notification) }

    context 'when the author' do
      before { sign_in question_notification.user }

      it 'deletes question notification' do
        expect {
          delete :destroy, params: { id: question_notification, format: :js }
        }.to change(QuestionNotification, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: {
          id: question_notification, format: :js
        }
        expect(response).to render_template :destroy
      end
    end

    context 'when not the author' do
      login_user

      it 'does not delete question' do
        expect {
          delete :destroy, params: { id: question_notification, format: :js }
        }.to_not change(QuestionNotification, :count)
      end

      it 'status is forbidden' do
        delete :destroy, params: { id: question_notification, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
