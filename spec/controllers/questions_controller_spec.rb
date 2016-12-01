require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'loads all of the questions into @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assings a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new attachments for a answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    login_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new attachments for a question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'saves the new question with the current user' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(subject.current_user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:invalid_question) }
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }

    context 'when the author' do
      before { sign_in question.user }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'when not the author' do
      login_user

      before { question }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to show question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end
end
