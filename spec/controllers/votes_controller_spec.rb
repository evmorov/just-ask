require 'rails_helper'

describe VotesController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #upvote' do
    login_user

    context 'with valid attributes' do
      it 'creates an upvote if there is no upvote by the user for the question' do
        expect {
          post :upvote, params: { question_id: question.id }
        }.to change(question.votes, :count).by(1)
      end

      it 'creates an upvote and not a downvote' do
        post :upvote, params: { question_id: question.id }
        expect(question.votes.first.score).to eq(1)
      end

      it 'removes a upvote if there is upvote by the same user for the question' do
        create(:vote, score: 1, user: @user, votable: question)
        expect {
          post :upvote, params: { question_id: question.id }
        }.to change(question.votes, :count).by(-1)
      end

      it 'creates an upvote if there is a downvote already' do
        create(:vote, score: -1, user: @user, votable: question)
        post :upvote, params: { question_id: question.id }
        expect(question.votes.first.score).to eq(1)
      end
    end
  end

  describe 'POST #downvote' do
    login_user

    context 'with valid attributes' do
      it 'creates a downvote if there is no downvote by the user for the question' do
        expect {
          post :downvote, params: { question_id: question.id }
        }.to change(question.votes, :count).by(1)
      end

      it 'creates a downvote and not an upvote' do
        post :downvote, params: { question_id: question.id }
        expect(question.votes.first.score).to eq(-1)
      end

      it 'removes a downvote if there is a downvote by the same user for the question' do
        create(:vote, score: -1, user: @user, votable: question)
        post :downvote, params: { question_id: question.id }
        expect(question.votes).to be_empty
      end
    end
  end
end
