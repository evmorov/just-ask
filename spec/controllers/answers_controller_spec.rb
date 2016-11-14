require 'rails_helper'

describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        }.to change(Answer, :count).by(1)
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
end
