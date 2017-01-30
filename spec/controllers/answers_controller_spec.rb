require 'rails_helper'

describe AnswersController, type: :controller do
  it_behaves_like 'votes' do
    let(:votable) { create(:answer) }
  end

  let(:question) { create(:question) }

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create, params: {
            answer: attributes_for(:answer), question_id: question, format: :js
          }
        }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer with the current user' do
        expect {
          post :create, params: {
            answer: attributes_for(:answer), question_id: question, format: :js
          }
        }.to change(subject.current_user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: {
          answer: attributes_for(:answer), question_id: question, format: :js
        }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: {
            answer: attributes_for(:invalid_answer), question_id: question, format: :js
          }
        }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: {
          answer: attributes_for(:invalid_answer), question_id: question, format: :js
        }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }

    context 'when the author' do
      before { sign_in answer.user }

      it 'assings the requested answer to @answer' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(assigns(:answer)).to eq(answer)
      end

      it 'assigns the question' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(assigns(:question)).to eq(question)
      end

      it 'changes the answer attributes' do
        patch :update, params: {
          answer: { body: 'new body' }, question_id: question, id: answer, format: :js
        }
        answer.reload
        expect(answer.body).to eq('new body')
      end

      it 'render update template' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(response).to render_template :update
      end
    end

    context 'when not the author' do
      login_user

      it 'assings the requested answer to @answer' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(assigns(:answer)).to eq(answer)
      end

      it 'assigns the question' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(assigns(:question)).to eq(question)
      end

      it 'does not change the answer attributes' do
        old_body = answer.body
        patch :update, params: {
          answer: { body: 'new body' }, question_id: question, id: answer, format: :js
        }
        answer.reload
        expect(answer.body).to eq(old_body)
      end

      it 'http status is forbidden' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question: question) }

    context 'when the author' do
      before { sign_in answer.user }

      it 'deletes answer' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.to change(question.answers, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not the author' do
      login_user

      before { answer }

      it 'does not delete answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to_not change(Answer, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #best_answer' do
    login_user

    let(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: question) }

    it 'render best_answer template' do
      post :best, params: { id: answer, format: :js }
      expect(response).to render_template :best
    end
  end
end
