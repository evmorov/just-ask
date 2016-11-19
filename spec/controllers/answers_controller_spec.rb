require 'rails_helper'

describe AnswersController, type: :controller do
  describe 'POST #create' do
    login_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer with the right user' do
        expect {
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        }.to change(subject.current_user.answers, :count).by(1)
      end

      it 'redirects to show the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        }.to_not change(Answer, :count)
      end

      it 're-renders show question view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }

    context 'when the author' do
      before { sign_in answer.user }

      it 'deletes answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to change(answer.question.answers, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when not the author' do
      login_user

      before { answer }

      it 'deletes answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to change(answer.question.answers, :count).by(0)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
