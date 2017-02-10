require 'rails_helper'

describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new question subscription in the database' do
        expect {
          post :create, params: { question_id: question, format: :js }
        }.to change(Subscription, :count).by(1)
      end

      it 'saves the new question subscription with the current user' do
        expect {
          post :create, params: { question_id: question, format: :js }
        }.to change(subject.current_user.subscriptions, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription) }

    context 'when the author' do
      before { sign_in subscription.user }

      it 'deletes question subscription' do
        expect {
          delete :destroy, params: { id: subscription, format: :js }
        }.to change(Subscription, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: {
          id: subscription, format: :js
        }
        expect(response).to render_template :destroy
      end
    end

    context 'when not the author' do
      login_user

      it 'does not delete question' do
        expect {
          delete :destroy, params: { id: subscription, format: :js }
        }.to_not change(Subscription, :count)
      end

      it 'status is forbidden' do
        delete :destroy, params: { id: subscription, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
