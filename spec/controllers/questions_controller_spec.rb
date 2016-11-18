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

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
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
    login_user

    before { @question = create(:question, user: subject.current_user) }

    it 'deletes answer' do
      expect { delete :destroy, params: { id: @question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: @question }
      expect(response).to redirect_to questions_path
    end
  end
end
