require 'rails_helper'

shared_examples 'votes' do
  describe 'POST #upvote' do
    context 'when not the owner of votable' do
      login_user

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

    context 'when the owner of votable' do
      before { sign_in votable.user }

      it "doesn't create a vote" do
        expect {
          post :upvote, params: { id: votable }, format: :json
        }.to_not change(votable.votes, :count)
      end

      it 'http status is forbidden' do
        post :upvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #downvote' do
    context 'when not the owner of votable' do
      login_user

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

    context 'when the owner of votable' do
      before { sign_in votable.user }

      it "doesn't create a vote" do
        expect {
          post :downvote, params: { id: votable }, format: :json
        }.to_not change(votable.votes, :count)
      end

      it 'http status is forbidden' do
        post :downvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
