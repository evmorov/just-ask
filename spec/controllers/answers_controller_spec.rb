require 'rails_helper'

describe AnswersController, type: :controller do
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

      it 'redirects to question view' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: answer, format: :js
        }
        expect(response).to redirect_to question
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

      it 'redirects to question view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'POST #best_answer' do
    let(:answer) { create(:answer, best: false) }

    login_user

    it 'render best_answer template' do
      post :best, params: { answer_id: answer, format: :js }
      expect(response).to render_template :best
    end

    it 'toggles the best attribute' do
      post :best, params: { answer_id: answer, format: :js }
      answer.reload

      expect(answer.best).to be(true)

      post :best, params: { answer_id: answer, format: :js }
      answer.reload

      expect(answer.best).to be(false)
    end

    it 'if question has answer with best=true then make it false and another question true' do
      best_answer = create(:answer, question: answer.question, best: true)

      post :best, params: { answer_id: answer, format: :js }
      best_answer.reload
      answer.reload

      expect(best_answer.best).to be(false)
      expect(answer.best).to be(true)
    end
  end
end
