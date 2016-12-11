require 'rails_helper'

shared_examples 'votes' do
  login_user

  describe 'POST #upvote' do
    it 'creates a vote' do
      expect {
        post :upvote, params: { id: votable }, format: :json
      }.to change(votable.votes, :count).by(1)
    end

    it 'creates a upvote' do
      post :upvote, params: { id: votable }, format: :json
      expect(votable.total_score).to eq(1)
    end
  end

  describe 'POST #downvote' do
    it 'creates a vote' do
      expect {
        post :downvote, params: { id: votable }, format: :json
      }.to change(votable.votes, :count).by(1)
    end

    it 'creates a downvote' do
      post :downvote, params: { id: votable }, format: :json
      expect(votable.total_score).to eq(-1)
    end
  end
end
