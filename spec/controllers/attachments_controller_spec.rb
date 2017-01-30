require 'rails_helper'

describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }
  let(:another_user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'when the author' do
      before { sign_in user }

      it 'assigns the deleted attachment to @attachment' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(assigns(:attachment)).to eq(attachment)
      end

      it 'deletes attachment' do
        expect {
          delete :destroy, params: { id: attachment }, format: :js
        }.to change(question.reload.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not the author' do
      before { sign_in another_user }

      it 'assigns the deleted attachment to @attachment' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(assigns(:attachment)).to eq(attachment)
      end

      it 'does not delete attachment' do
        expect {
          delete :destroy, params: { id: attachment }, format: :js
        }.to_not change(question.reload.attachments, :count)
      end

      it 'http status is forbidden' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
