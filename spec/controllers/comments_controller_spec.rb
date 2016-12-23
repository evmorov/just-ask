require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }
  let(:another_user) { create(:user) }

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new comment for a question in the database' do
        expect {
          post :create, params: {
            comment: attributes_for(:comment),
            question_id: question
          }, format: :json
        }.to change(question.comments, :count).by(1)
      end

      it 'saves the new comment for an answer in the database' do
        expect {
          post :create, params: {
            comment: attributes_for(:comment),
            answer_id: answer
          }, format: :json
        }.to change(answer.comments, :count).by(1)
      end

      it 'answers with json' do
        post :create, params: {
          comment: attributes_for(:comment),
          question_id: question
        }, format: :json
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect {
          post :create, params: {
            comment: attributes_for(:invalid_comment),
            question_id: question
          }, format: :json
        }.to_not change(question.comments, :count)
      end

      it 'answers with json' do
        post :create, params: {
          comment: attributes_for(:invalid_comment),
          question_id: question
        }, format: :json
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
